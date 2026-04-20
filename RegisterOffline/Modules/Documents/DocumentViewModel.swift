//
//  DocumentViewModel.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import Foundation
import Combine
import UIKit

@MainActor
final class DocumentViewModel: ObservableObject {
    @Published var uploadedMembers: [UploadedMemberModel] = []
    @Published var draftMembers: [MemberDraftModel] = []
    @Published var isLoadingUploadedMembers = false
    @Published var isBulkUploadingDrafts = false
    @Published var draftSyncMessage: String?
    @Published var uploadedMembersErrorMessage: String?

    private let repository: MemberRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var hasLoadedUploadedMembers = false

    init(repository: MemberRepositoryProtocol) {
        self.repository = repository
    }

    func loadUploadedMembersIfNeeded() {
        guard !hasLoadedUploadedMembers else { return }
        loadUploadedMembers()
    }

    func loadUploadedMembers() {
        guard !isLoadingUploadedMembers else { return }

        isLoadingUploadedMembers = true
        uploadedMembersErrorMessage = nil

        repository.getUploadedMembers()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoadingUploadedMembers = false

                if case let .failure(error) = completion {
                    self.uploadedMembersErrorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] memberResponses in
                guard let self else { return }
                let members = memberResponses.enumerated().map { index, response in
                    UploadedMemberModel(
                        id: response.nik ?? "\(index)",
                        name: response.name ?? "-",
                        nik: response.nik ?? "-",
                        phone: response.phone ?? "-",
                        ktpURL: response.ktpURL,
                        ktpURLSecondary: response.ktpURLSecondary
                    )
                }
                self.uploadedMembers = members
                self.hasLoadedUploadedMembers = true
            }
            .store(in: &cancellables)
    }

    func loadDraftMembers() {
        draftMembers = repository.getDrafts().filter { $0.draftStatus == .draft }
    }

    func deleteDraft(id: String) {
        repository.deleteDraft(id: id)
        loadDraftMembers()
    }

    func uploadDraft(_ draft: MemberDraftModel) {
        guard let request = makeUploadRequest(from: draft) else { return }
        repository.uploadMember(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.draftSyncMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                let syncedDraft = draft.withDraftStatus(.synced)
                self.repository.saveDraft(syncedDraft)
                self.loadDraftMembers()
                self.loadUploadedMembers()
            }
            .store(in: &cancellables)
    }

    func uploadAllDrafts() {
        let pendingDrafts = repository.getDrafts().filter { $0.draftStatus == .draft }
        guard !pendingDrafts.isEmpty, !isBulkUploadingDrafts else { return }

        isBulkUploadingDrafts = true
        draftSyncMessage = nil
        uploadNextDraft(at: 0, drafts: pendingDrafts)
    }

    private func uploadNextDraft(at index: Int, drafts: [MemberDraftModel]) {
        guard index < drafts.count else {
            isBulkUploadingDrafts = false
            draftSyncMessage = "Semua draft berhasil disinkronkan."
            loadDraftMembers()
            loadUploadedMembers()
            return
        }

        let draft = drafts[index]
        guard let request = makeUploadRequest(from: draft) else {
            uploadNextDraft(at: index + 1, drafts: drafts)
            return
        }

        repository.uploadMember(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                if case let .failure(error) = completion {
                    self.draftSyncMessage = error.localizedDescription
                }
                self.uploadNextDraft(at: index + 1, drafts: drafts)
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                let syncedDraft = draft.withDraftStatus(.synced)
                self.repository.saveDraft(syncedDraft)
            }
            .store(in: &cancellables)
    }

    private func makeUploadRequest(from draft: MemberDraftModel) -> UploadMemberRequestModel? {
        guard let primaryImageData = compressedJPEGData(from: draft.primaryImageData, maxBytes: 1_900_000),
              let secondaryImageData = compressedJPEGData(from: draft.secondaryImageData, maxBytes: 1_900_000) else {
            return nil
        }

        return UploadMemberRequestModel(
            name: draft.name,
            nik: draft.nik,
            phone: draft.phone,
            birthPlace: draft.birthPlace,
            birthDate: draft.birthDate,
            status: draft.maritalStatus,
            occupation: draft.occupation,
            address: draft.address,
            provinsi: draft.provinsi,
            kotaKabupaten: draft.kotaKabupaten,
            kecamatan: draft.kecamatan,
            kelurahan: draft.kelurahan,
            kodePos: draft.kodePos,
            alamatDomisili: draft.alamatDomisili,
            provinsiDomisili: draft.provinsiDomisili,
            kotaKabupatenDomisili: draft.kotaKabupatenDomisili,
            kecamatanDomisili: draft.kecamatanDomisili,
            kelurahanDomisili: draft.kelurahanDomisili,
            kodePosDomisili: draft.kodePosDomisili,
            primaryImageData: primaryImageData,
            secondaryImageData: secondaryImageData
        )
    }

    private func compressedJPEGData(from data: Data?, maxBytes: Int) -> Data? {
        guard
            let data,
            let image = UIImage(data: data)
        else { return nil }

        let maxDimension: CGFloat = 1800
        let sourceSize = image.size
        let scale = min(1, maxDimension / max(sourceSize.width, sourceSize.height))
        let targetSize = CGSize(width: sourceSize.width * scale, height: sourceSize.height * scale)

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        var compression: CGFloat = 0.82
        var bestData: Data? = resizedImage.jpegData(compressionQuality: compression)

        while compression > 0.2, let compressed = bestData, compressed.count > maxBytes {
            compression -= 0.08
            bestData = resizedImage.jpegData(compressionQuality: compression)
        }

        guard let finalData = bestData, finalData.count <= maxBytes else { return nil }
        return finalData
    }
}

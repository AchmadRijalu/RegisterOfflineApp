//
//  CreateDocumentViewModel.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import SwiftUI
import Combine
import UIKit

@MainActor
final class CreateDocumentViewModel: ObservableObject {
    struct FormInput {
        let name: String
        let nik: String
        let phone: String
        let birthPlace: String
        let birthDate: String
        let status: String
        let occupation: String
        let address: String
        let provinsi: String
        let kotaKabupaten: String
        let kecamatan: String
        let kelurahan: String
        let kodePos: String
        let alamatDomisili: String
        let provinsiDomisili: String
        let kotaKabupatenDomisili: String
        let kecamatanDomisili: String
        let kelurahanDomisili: String
        let kodePosDomisili: String
    }

    @Published var isUploading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var didUploadSuccess = false

    private let repository: MemberRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: MemberRepositoryProtocol) {
        self.repository = repository
    }

    func saveDraft(input: FormInput, primaryImage: UIImage?, secondaryImage: UIImage?) {
        let draft = MemberDraftModel(
            id: UUID().uuidString,
            name: input.name,
            nik: input.nik,
            phone: input.phone,
            birthPlace: input.birthPlace,
            birthDate: input.birthDate,
            maritalStatus: input.status,
            occupation: input.occupation,
            address: input.address,
            provinsi: input.provinsi,
            kotaKabupaten: input.kotaKabupaten,
            kecamatan: input.kecamatan,
            kelurahan: input.kelurahan,
            kodePos: input.kodePos,
            alamatDomisili: input.alamatDomisili,
            provinsiDomisili: input.provinsiDomisili,
            kotaKabupatenDomisili: input.kotaKabupatenDomisili,
            kecamatanDomisili: input.kecamatanDomisili,
            kelurahanDomisili: input.kelurahanDomisili,
            kodePosDomisili: input.kodePosDomisili,
            primaryImageData: primaryImage?.jpegData(compressionQuality: 0.75),
            secondaryImageData: secondaryImage?.jpegData(compressionQuality: 0.75),
            createdAt: Date(),
            draftStatus: .draft
        )
        repository.saveDraft(draft)
        successMessage = "Draft berhasil disimpan"
        errorMessage = nil
    }

    func uploadMember(input: FormInput, primaryImage: UIImage?, secondaryImage: UIImage?) {
        let trimmedName = input.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNik = input.nik.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = input.phone.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty, !trimmedNik.isEmpty, !trimmedPhone.isEmpty else {
            errorMessage = "Nama, NIK, dan nomor handphone wajib diisi."
            return
        }

        guard
            let primaryImage,
            let secondaryImage,
            let primaryImageData = compressedJPEGData(from: primaryImage, maxBytes: 1_900_000),
            let secondaryImageData = compressedJPEGData(from: secondaryImage, maxBytes: 1_900_000)
        else {
            errorMessage = "Foto KTP utama dan pendukung wajib diisi."
            return
        }

        isUploading = true
        errorMessage = nil
        successMessage = nil
        didUploadSuccess = false

        let request = UploadMemberRequestModel(
            name: trimmedName,
            nik: trimmedNik,
            phone: trimmedPhone,
            birthPlace: input.birthPlace,
            birthDate: input.birthDate,
            status: input.status,
            occupation: input.occupation,
            address: input.address,
            provinsi: input.provinsi,
            kotaKabupaten: input.kotaKabupaten,
            kecamatan: input.kecamatan,
            kelurahan: input.kelurahan,
            kodePos: input.kodePos,
            alamatDomisili: input.alamatDomisili,
            provinsiDomisili: input.provinsiDomisili,
            kotaKabupatenDomisili: input.kotaKabupatenDomisili,
            kecamatanDomisili: input.kecamatanDomisili,
            kelurahanDomisili: input.kelurahanDomisili,
            kodePosDomisili: input.kodePosDomisili,
            primaryImageData: primaryImageData,
            secondaryImageData: secondaryImageData
        )

        repository.uploadMember(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isUploading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                self?.successMessage = response.message ?? "Upload berhasil"
                self?.didUploadSuccess = true
            }
            .store(in: &cancellables)
    }

    private func compressedJPEGData(from image: UIImage, maxBytes: Int) -> Data? {
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

        while compression > 0.2, let data = bestData, data.count > maxBytes {
            compression -= 0.08
            bestData = resizedImage.jpegData(compressionQuality: compression)
        }

        guard let finalData = bestData, finalData.count <= maxBytes else { return nil }
        return finalData
    }
}

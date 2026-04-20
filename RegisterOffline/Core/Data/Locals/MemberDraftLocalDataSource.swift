//
//  MemberDraftLocalDataSource.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import Foundation
import SwiftData

protocol MemberDraftLocalDataSourceProtocol: AnyObject {
    func saveDraft(_ draft: MemberDraftModel)
    func getDrafts() -> [MemberDraftModel]
    func deleteDraft(id: String)
}

@MainActor
final class MemberDraftLocalDataSource: MemberDraftLocalDataSourceProtocol {
    private let context: ModelContext

    static let sharedInstance = MemberDraftLocalDataSource(
        context: SwiftDataStack.shared.container.mainContext
    )

    init(context: ModelContext) {
        self.context = context
    }

    func saveDraft(_ draft: MemberDraftModel) {
        let descriptor = FetchDescriptor<MemberDraftEntity>(
            predicate: #Predicate { $0.id == draft.id }
        )

        if let existing = try? context.fetch(descriptor).first {
            existing.name = draft.name
            existing.nik = draft.nik
            existing.phone = draft.phone
            existing.birthPlace = draft.birthPlace
            existing.birthDate = draft.birthDate
            existing.maritalStatus = draft.maritalStatus
            existing.occupation = draft.occupation
            existing.address = draft.address
            existing.provinsi = draft.provinsi
            existing.kotaKabupaten = draft.kotaKabupaten
            existing.kecamatan = draft.kecamatan
            existing.kelurahan = draft.kelurahan
            existing.kodePos = draft.kodePos
            existing.alamatDomisili = draft.alamatDomisili
            existing.provinsiDomisili = draft.provinsiDomisili
            existing.kotaKabupatenDomisili = draft.kotaKabupatenDomisili
            existing.kecamatanDomisili = draft.kecamatanDomisili
            existing.kelurahanDomisili = draft.kelurahanDomisili
            existing.kodePosDomisili = draft.kodePosDomisili
            existing.primaryImageData = draft.primaryImageData
            existing.secondaryImageData = draft.secondaryImageData
            existing.createdAt = draft.createdAt
            existing.draftStatusRaw = draft.draftStatus.rawValue
        } else {
            let newEntity = MemberDraftEntity(
                id: draft.id,
                name: draft.name,
                nik: draft.nik,
                phone: draft.phone,
                birthPlace: draft.birthPlace,
                birthDate: draft.birthDate,
                maritalStatus: draft.maritalStatus,
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
                primaryImageData: draft.primaryImageData,
                secondaryImageData: draft.secondaryImageData,
                createdAt: draft.createdAt,
                draftStatusRaw: draft.draftStatus.rawValue
            )
            context.insert(newEntity)
        }

        try? context.save()
    }

    func getDrafts() -> [MemberDraftModel] {
        let descriptor = FetchDescriptor<MemberDraftEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )

        let entities = (try? context.fetch(descriptor)) ?? []
        return entities.map { entity in
            MemberDraftModel(
                id: entity.id,
                name: entity.name,
                nik: entity.nik,
                phone: entity.phone,
                birthPlace: entity.birthPlace,
                birthDate: entity.birthDate,
                maritalStatus: entity.maritalStatus,
                occupation: entity.occupation,
                address: entity.address,
                provinsi: entity.provinsi,
                kotaKabupaten: entity.kotaKabupaten,
                kecamatan: entity.kecamatan,
                kelurahan: entity.kelurahan,
                kodePos: entity.kodePos,
                alamatDomisili: entity.alamatDomisili,
                provinsiDomisili: entity.provinsiDomisili,
                kotaKabupatenDomisili: entity.kotaKabupatenDomisili,
                kecamatanDomisili: entity.kecamatanDomisili,
                kelurahanDomisili: entity.kelurahanDomisili,
                kodePosDomisili: entity.kodePosDomisili,
                primaryImageData: entity.primaryImageData,
                secondaryImageData: entity.secondaryImageData,
                createdAt: entity.createdAt,
                draftStatus: MemberDraftStatus(rawValue: entity.draftStatusRaw) ?? .draft
            )
        }
    }

    func deleteDraft(id: String) {
        let descriptor = FetchDescriptor<MemberDraftEntity>(
            predicate: #Predicate { $0.id == id }
        )

        if let entity = try? context.fetch(descriptor).first {
            context.delete(entity)
            try? context.save()
        }
    }
}

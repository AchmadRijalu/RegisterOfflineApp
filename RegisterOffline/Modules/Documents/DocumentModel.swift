//
//  DocumentModel.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import Foundation

enum MemberDraftStatus: String, Codable {
    case draft = "Draft"
    case synced = "Synced"
}

struct UploadedMemberModel: Identifiable {
    let id: String
    let name: String
    let nik: String
    let phone: String
    let ktpURL: String?
    let ktpURLSecondary: String?
}

struct MemberDraftModel: Identifiable, Codable {
    let id: String
    let name: String
    let nik: String
    let phone: String
    let birthPlace: String
    let birthDate: String
    let maritalStatus: String
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
    let primaryImageData: Data?
    let secondaryImageData: Data?
    let createdAt: Date
    let draftStatus: MemberDraftStatus

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case nik
        case phone
        case birthPlace = "birth_place"
        case birthDate = "birth_date"
        case maritalStatus = "status"
        case occupation
        case address
        case provinsi
        case kotaKabupaten = "kota_kabupaten"
        case kecamatan
        case kelurahan
        case kodePos = "kode_pos"
        case alamatDomisili = "alamat_domisili"
        case provinsiDomisili = "provinsi_domisili"
        case kotaKabupatenDomisili = "kota_kabupaten_domisili"
        case kecamatanDomisili = "kecamatan_domisili"
        case kelurahanDomisili = "kelurahan_domisili"
        case kodePosDomisili = "kode_pos_domisili"
        case primaryImageData
        case secondaryImageData
        case createdAt
        case draftStatus
    }

    init(
        id: String,
        name: String,
        nik: String,
        phone: String,
        birthPlace: String,
        birthDate: String,
        maritalStatus: String,
        occupation: String,
        address: String,
        provinsi: String,
        kotaKabupaten: String,
        kecamatan: String,
        kelurahan: String,
        kodePos: String,
        alamatDomisili: String,
        provinsiDomisili: String,
        kotaKabupatenDomisili: String,
        kecamatanDomisili: String,
        kelurahanDomisili: String,
        kodePosDomisili: String,
        primaryImageData: Data?,
        secondaryImageData: Data?,
        createdAt: Date,
        draftStatus: MemberDraftStatus
    ) {
        self.id = id
        self.name = name
        self.nik = nik
        self.phone = phone
        self.birthPlace = birthPlace
        self.birthDate = birthDate
        self.maritalStatus = maritalStatus
        self.occupation = occupation
        self.address = address
        self.provinsi = provinsi
        self.kotaKabupaten = kotaKabupaten
        self.kecamatan = kecamatan
        self.kelurahan = kelurahan
        self.kodePos = kodePos
        self.alamatDomisili = alamatDomisili
        self.provinsiDomisili = provinsiDomisili
        self.kotaKabupatenDomisili = kotaKabupatenDomisili
        self.kecamatanDomisili = kecamatanDomisili
        self.kelurahanDomisili = kelurahanDomisili
        self.kodePosDomisili = kodePosDomisili
        self.primaryImageData = primaryImageData
        self.secondaryImageData = secondaryImageData
        self.createdAt = createdAt
        self.draftStatus = draftStatus
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        nik = try container.decode(String.self, forKey: .nik)
        phone = try container.decode(String.self, forKey: .phone)
        birthPlace = try container.decodeIfPresent(String.self, forKey: .birthPlace) ?? ""
        birthDate = try container.decodeIfPresent(String.self, forKey: .birthDate) ?? ""
        maritalStatus = try container.decodeIfPresent(String.self, forKey: .maritalStatus) ?? ""
        occupation = try container.decodeIfPresent(String.self, forKey: .occupation) ?? ""
        address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        provinsi = try container.decodeIfPresent(String.self, forKey: .provinsi) ?? ""
        kotaKabupaten = try container.decodeIfPresent(String.self, forKey: .kotaKabupaten) ?? ""
        kecamatan = try container.decodeIfPresent(String.self, forKey: .kecamatan) ?? ""
        kelurahan = try container.decodeIfPresent(String.self, forKey: .kelurahan) ?? ""
        kodePos = try container.decodeIfPresent(String.self, forKey: .kodePos) ?? ""
        alamatDomisili = try container.decodeIfPresent(String.self, forKey: .alamatDomisili) ?? ""
        provinsiDomisili = try container.decodeIfPresent(String.self, forKey: .provinsiDomisili) ?? ""
        kotaKabupatenDomisili = try container.decodeIfPresent(String.self, forKey: .kotaKabupatenDomisili) ?? ""
        kecamatanDomisili = try container.decodeIfPresent(String.self, forKey: .kecamatanDomisili) ?? ""
        kelurahanDomisili = try container.decodeIfPresent(String.self, forKey: .kelurahanDomisili) ?? ""
        kodePosDomisili = try container.decodeIfPresent(String.self, forKey: .kodePosDomisili) ?? ""
        primaryImageData = try container.decodeIfPresent(Data.self, forKey: .primaryImageData)
        secondaryImageData = try container.decodeIfPresent(Data.self, forKey: .secondaryImageData)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        draftStatus = try container.decodeIfPresent(MemberDraftStatus.self, forKey: .draftStatus) ?? .draft
    }

    func withDraftStatus(_ status: MemberDraftStatus) -> MemberDraftModel {
        MemberDraftModel(
            id: id,
            name: name,
            nik: nik,
            phone: phone,
            birthPlace: birthPlace,
            birthDate: birthDate,
            maritalStatus: maritalStatus,
            occupation: occupation,
            address: address,
            provinsi: provinsi,
            kotaKabupaten: kotaKabupaten,
            kecamatan: kecamatan,
            kelurahan: kelurahan,
            kodePos: kodePos,
            alamatDomisili: alamatDomisili,
            provinsiDomisili: provinsiDomisili,
            kotaKabupatenDomisili: kotaKabupatenDomisili,
            kecamatanDomisili: kecamatanDomisili,
            kelurahanDomisili: kelurahanDomisili,
            kodePosDomisili: kodePosDomisili,
            primaryImageData: primaryImageData,
            secondaryImageData: secondaryImageData,
            createdAt: createdAt,
            draftStatus: status
        )
    }
}

struct UploadMemberRequestModel {
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
    let primaryImageData: Data
    let secondaryImageData: Data
}

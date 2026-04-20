//
//  MemberDraftEntity.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 21/04/26.
//

import Foundation
import SwiftData

@Model
final class MemberDraftEntity {
    @Attribute(.unique) var id: String
    var name: String
    var nik: String
    var phone: String
    var birthPlace: String
    var birthDate: String
    var maritalStatus: String
    var occupation: String
    var address: String
    var provinsi: String
    var kotaKabupaten: String
    var kecamatan: String
    var kelurahan: String
    var kodePos: String
    var alamatDomisili: String
    var provinsiDomisili: String
    var kotaKabupatenDomisili: String
    var kecamatanDomisili: String
    var kelurahanDomisili: String
    var kodePosDomisili: String
    var primaryImageData: Data?
    var secondaryImageData: Data?
    var createdAt: Date
    var draftStatusRaw: String

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
        draftStatusRaw: String
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
        self.draftStatusRaw = draftStatusRaw
    }
}

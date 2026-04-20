//
//  CreateDocumentView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import SwiftUI

struct CreateDocumentView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @ObservedObject var viewModel: CreateDocumentViewModel

    @State private var phone = ""
    @State private var nik = ""
    @State private var fullName = ""
    @State private var birthPlace = ""
    @State private var birthDate = ""
    @State private var job = ""
    @State private var addressKtp = ""
    @State private var postalCode = ""

    @State private var gender = ""
    @State private var maritalStatus = ""
    @State private var province = ""
    @State private var city = ""
    @State private var district = ""
    @State private var subDistrict = ""
    @State private var domicileAddress = ""
    @State private var domicileProvince = ""
    @State private var domicileCity = ""
    @State private var domicileDistrict = ""
    @State private var domicileSubDistrict = ""
    @State private var domicilePostalCode = ""
    @State private var isSameDomicileAddress = true

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Data Utama")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brandSecondary)

                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.brandSecondary)
                            .font(.system(size: 14))
                            .padding(.top, 2)

                        Text("Pastikan foto KTP sudah jelas dan sesuai data agar proses verifikasi berhasil.")
                            .font(.system(size: 12))
                            .foregroundColor(.brandSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(Color(hex: "#EEF2FF"))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                    GeneralTextField(
                        title: "Nomor Handphone *",
                        placeholder: "Masukkan nomor handphone",
                        text: $phone,
                        keyboardType: .phonePad
                    )

                    GeneralTextField(
                        title: "NIK *",
                        placeholder: "Masukkan NIK KTP",
                        text: $nik,
                        keyboardType: .numberPad
                    )

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Foto KTP *")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.textPrimary)

                        Text("Ambil 2 foto KTP (depan dan pojok kiri atas). Pastikan KTP terlihat jelas dan tidak blur.")
                            .font(.system(size: 12))
                            .foregroundColor(.textSecondary)

                        HStack(spacing: 12) {
                            Button {
                                coordinator.currentCaptureSlot = .primary
                                coordinator.push(page: .camera)
                            } label: {
                                ZStack {
                                    if let primaryImage = coordinator.primaryKtpImage {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(Color(hex: "#F8FAFC"))
                                            .padding(8)
                                            .overlay {
                                                Image(uiImage: primaryImage)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .padding(12)
                                            }
                                    } else {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.brandSecondary)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 92)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)

                            Button {
                                coordinator.currentCaptureSlot = .secondary
                                coordinator.push(page: .camera)
                            } label: {
                                ZStack {
                                    if let secondaryImage = coordinator.secondaryKtpImage {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(Color(hex: "#F8FAFC"))
                                            .padding(8)
                                            .overlay {
                                                Image(uiImage: secondaryImage)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .padding(12)
                                            }
                                    } else {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.brandSecondary)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 92)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Text("Informasi Lainnya")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brandSecondary)
                        .padding(.top, 8)

                    GeneralTextField(
                        title: "Nama Lengkap",
                        placeholder: "Masukkan nama sesuai KTP",
                        text: $fullName
                    )

                    GeneralTextField(
                        title: "Tempat Lahir",
                        placeholder: "Masukkan tempat lahir sesuai KTP",
                        text: $birthPlace
                    )

                    GeneralTextField(
                        title: "Tanggal Lahir",
                        placeholder: "DD/MM/YYYY",
                        text: $birthDate,
                        trailingSystemIcon: "calendar"
                    )

                    GeneralDropdownField(
                        title: "Jenis Kelamin",
                        placeholder: "Pilih jenis kelamin",
                        options: ["Laki-laki", "Perempuan"],
                        selection: $gender
                    )

                    GeneralDropdownField(
                        title: "Status",
                        placeholder: "Pilih status sesuai KTP",
                        options: ["Belum Menikah", "Menikah", "Cerai"],
                        selection: $maritalStatus
                    )

                    GeneralTextField(
                        title: "Pekerjaan",
                        placeholder: "Pilih pekerjaan sesuai KTP",
                        text: $job
                    )

                    Text("Informasi Alamat KTP")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brandSecondary)
                        .padding(.top, 8)

                    GeneralTextField(
                        title: "Alamat Lengkap",
                        placeholder: "Masukkan alamat sesuai KTP",
                        text: $addressKtp
                    )

                    GeneralDropdownField(
                        title: "Provinsi",
                        placeholder: "Pilih Provinsi",
                        options: ["DKI Jakarta", "Jawa Barat", "Banten"],
                        selection: $province
                    )

                    GeneralDropdownField(
                        title: "Kota/Kabupaten",
                        placeholder: "Pilih Kota/Kabupaten",
                        options: ["Jakarta Pusat", "Jakarta Selatan", "Depok"],
                        selection: $city
                    )

                    GeneralDropdownField(
                        title: "Kecamatan",
                        placeholder: "Pilih Kecamatan",
                        options: ["Menteng", "Tanah Abang", "Setiabudi"],
                        selection: $district
                    )

                    GeneralDropdownField(
                        title: "Kelurahan",
                        placeholder: "Pilih Kelurahan",
                        options: ["Kebon Sirih", "Cikini", "Gondangdia"],
                        selection: $subDistrict
                    )

                    GeneralTextField(
                        title: "Kode Pos",
                        placeholder: "Masukkan kode pos",
                        text: $postalCode,
                        keyboardType: .numberPad
                    )

                    Text("Alamat Domisili")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brandSecondary)
                        .padding(.top, 8)

                    Toggle(isOn: $isSameDomicileAddress) {
                        Text("Alamat domisili sama dengan alamat pada KTP")
                            .font(.system(size: 14))
                            .foregroundColor(.textPrimary)
                    }

                    if !isSameDomicileAddress {
                        GeneralTextField(
                            title: "Alamat Domisili",
                            placeholder: "Masukkan alamat domisili",
                            text: $domicileAddress
                        )

                        GeneralDropdownField(
                            title: "Provinsi Domisili",
                            placeholder: "Pilih Provinsi",
                            options: ["DKI Jakarta", "Jawa Barat", "Banten"],
                            selection: $domicileProvince
                        )

                        GeneralDropdownField(
                            title: "Kota/Kabupaten Domisili",
                            placeholder: "Pilih Kota/Kabupaten",
                            options: ["Jakarta Pusat", "Jakarta Selatan", "Depok"],
                            selection: $domicileCity
                        )

                        GeneralDropdownField(
                            title: "Kecamatan Domisili",
                            placeholder: "Pilih Kecamatan",
                            options: ["Menteng", "Tanah Abang", "Setiabudi"],
                            selection: $domicileDistrict
                        )

                        GeneralDropdownField(
                            title: "Kelurahan Domisili",
                            placeholder: "Pilih Kelurahan",
                            options: ["Kebon Sirih", "Cikini", "Gondangdia"],
                            selection: $domicileSubDistrict
                        )

                        GeneralTextField(
                            title: "Kode Pos Domisili",
                            placeholder: "Masukkan kode pos domisili",
                            text: $domicilePostalCode,
                            keyboardType: .numberPad
                        )
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }

                    if let successMessage = viewModel.successMessage {
                        Text(successMessage)
                            .font(.footnote)
                            .foregroundColor(.green)
                    }

                    Color.clear
                        .frame(height: 148)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .background(Color.backgroundPrimary)

            VStack {
                GeneralButton(
                    title: "Upload",
                    type: .filled,
                    tint: .primary,
                    isLoading: viewModel.isUploading,
                    height: 52,
                    cornerRadius: 12,
                    titleFont: .system(size: 16, weight: .semibold),
                    action: {
                        viewModel.uploadMember(
                            input: makeFormInput(),
                            primaryImage: coordinator.primaryKtpImage,
                            secondaryImage: coordinator.secondaryKtpImage
                        )
                    }
                )

                GeneralButton(
                    title: "Simpan sebagai Draft",
                    type: .outlined,
                    tint: .primary,
                    height: 52,
                    cornerRadius: 12,
                    titleFont: .system(size: 16, weight: .semibold),
                    stroke: Color(hex: "#D1D5DB"),
                    fill: .white,
                    action: {
                        viewModel.saveDraft(
                            input: makeFormInput(),
                            primaryImage: coordinator.primaryKtpImage,
                            secondaryImage: coordinator.secondaryKtpImage
                        )
                        coordinator.pop()
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .background(.white)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.black.opacity(0.05))
                    .frame(height: 1)
            }
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: -2)
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.didUploadSuccess) { _, didUploadSuccess in
            guard didUploadSuccess else { return }
            coordinator.pop()
        }
    }

    private func makeFormInput() -> CreateDocumentViewModel.FormInput {
        let resolvedDomicileAddress = isSameDomicileAddress ? addressKtp : domicileAddress
        let resolvedDomicileProvince = isSameDomicileAddress ? province : domicileProvince
        let resolvedDomicileCity = isSameDomicileAddress ? city : domicileCity
        let resolvedDomicileDistrict = isSameDomicileAddress ? district : domicileDistrict
        let resolvedDomicileSubDistrict = isSameDomicileAddress ? subDistrict : domicileSubDistrict
        let resolvedDomicilePostalCode = isSameDomicileAddress ? postalCode : domicilePostalCode

        return .init(
            name: fullName,
            nik: nik,
            phone: phone,
            birthPlace: birthPlace,
            birthDate: birthDate,
            status: maritalStatus,
            occupation: job,
            address: addressKtp,
            provinsi: province,
            kotaKabupaten: city,
            kecamatan: district,
            kelurahan: subDistrict,
            kodePos: postalCode,
            alamatDomisili: resolvedDomicileAddress,
            provinsiDomisili: resolvedDomicileProvince,
            kotaKabupatenDomisili: resolvedDomicileCity,
            kecamatanDomisili: resolvedDomicileDistrict,
            kelurahanDomisili: resolvedDomicileSubDistrict,
            kodePosDomisili: resolvedDomicilePostalCode
        )
    }
}

#Preview {
    NavigationStack {
        CreateDocumentView(
            viewModel: CreateDocumentViewModel(
                repository: MemberRepository.sharedInstance(
                    MemberRemoteDataSource.sharedInstance(CredentialRepository()),
                    MemberDraftLocalDataSource.sharedInstance
                )
            )
        )
            .environmentObject(Coordinator(injection: Injection()))
    }
}

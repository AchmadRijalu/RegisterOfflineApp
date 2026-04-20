//
//  DocumentsView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import SwiftUI

private enum DocumentTab: Hashable, CaseIterable {
    case draft
    case uploaded
    
    var tabTitle: String {
        switch self {
        case .draft: return "Draft"
        case .uploaded: return "Sudah Di-Upload"
        }
    }
}

struct DocumentsView: View {
    @EnvironmentObject var coordinator: Coordinator
    @ObservedObject var viewModel: DocumentViewModel
    @State private var selectedTab: DocumentTab = .draft
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 8) {
                    Image(.imageRegisteroffline)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.brandSecondary)
                    
                    Text("Register Offline")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                
                Spacer(minLength: 12)
                
                HStack(spacing: 8) {
                    Text("Yudi Wiranto")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.brandSecondary)
                }
                .cardStyle(shape: .capsule, variant: .bordered, padding: 8, borderColor: Color(hex: "#E2E8F0"))
                .onTapGesture {
                    coordinator.push(page: .profile)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            
            SegmentedTabsView(selection: $selectedTab, title: \.tabTitle) { tab in
                switch tab {
                case .draft: DocumentDraftView(viewModel: viewModel)
                case .uploaded: DocumentUploadedView(viewModel: viewModel)
                }
            }
        }
        .background(Color.backgroundPrimary)
    }
    
}

struct DocumentDraftView: View {
    @EnvironmentObject var coordinator: Coordinator
    @ObservedObject var viewModel: DocumentViewModel

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.draftMembers.isEmpty {
                Spacer()
                Image(.imageUploadConfirmation)
                Text("Belum ada data")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)

                Text("Klik 'Tambah Data' untuk menambahkan data calon anggota")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 8)

                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("List Draft KTA")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .padding(.bottom, 4)

                        Text("Upload untuk mengirimkan data ini ke admin untuk di-verifikasi.")
                            .font(.system(size: 13))
                            .foregroundColor(.textSecondary)

                        ForEach(Array(viewModel.draftMembers.enumerated()), id: \.element.id) { index, draft in
                            DocumentDraftItem(
                                index: index + 1,
                                draft: draft,
                                onEdit: {
                                    coordinator.push(page: .createDocument)
                                },
                                onDelete: {
                                    viewModel.deleteDraft(id: draft.id)
                                },
                                onUpload: {
                                    viewModel.uploadDraft(draft)
                                }
                            )
                        }

                        if let message = viewModel.draftSyncMessage {
                            Text(message)
                                .font(.footnote)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }

            VStack {
                GeneralButton(
                    title: "Tambah Data",
                    type: .filled,
                    tint: .primary,
                    leadingSystemImage: "plus",
                    action: {
                        coordinator.push(page: .createDocument)
                    }
                )
                
                GeneralButton(
                    title: "Upload Semua",
                    type: .outlined,
                    tint: .primary,
                    isDisabled: viewModel.draftMembers.isEmpty || viewModel.isBulkUploadingDrafts,
                    isLoading: viewModel.isBulkUploadingDrafts,
                    titleFont: .system(size: 16, weight: .medium),
                    leadingSystemImage: "square.and.arrow.up",
                    disabledOpacity: 0.85,
                    foreground: (viewModel.draftMembers.isEmpty || viewModel.isBulkUploadingDrafts)
                        ? Color.textSecondary.opacity(0.55)
                        : .brandSecondary,
                    stroke: Color(hex: "#E2E8F0"),
                    fill: .white,
                    action: {
                        viewModel.uploadAllDrafts()
                    }
                )
            }
            .padding()
            .background(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.grayBackgroundColor)
        .onAppear {
            viewModel.loadDraftMembers()
        }
    }
}

struct DocumentUploadedView: View {
    @ObservedObject var viewModel: DocumentViewModel

    var body: some View {
        Group {
            if viewModel.isLoadingUploadedMembers {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if viewModel.uploadedMembers.isEmpty {
                VStack(spacing: 0) {
                    Text("Belum ada dokumen")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 24)

                    Text("Data yang sudah di-upload akan tampil di sini.")
                        .font(.system(size: 14))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.top, 8)

                    if let errorMessage = viewModel.uploadedMembersErrorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                    }
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.uploadedMembers) { member in
                            UploadedMemberRow(member: member)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.loadUploadedMembersIfNeeded()
        }
    }
}

private struct UploadedMemberRow: View {
    let member: UploadedMemberModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(member.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textPrimary)

            HStack {
                Text("NIK")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.textSecondary)
                Text(member.nik)
                    .font(.system(size: 13))
                    .foregroundColor(.textPrimary)
            }

            HStack {
                Text("Phone")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.textSecondary)
                Text(member.phone)
                    .font(.system(size: 13))
                    .foregroundColor(.textPrimary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(
            shape: .rounded,
            variant: .bordered,
            padding: 14,
            backgroundColor: .white,
            borderColor: Color(hex: "#E2E8F0"),
            borderWidth: 1
        )
    }
}

#Preview {
    DocumentsView(
        viewModel: DocumentViewModel(
            repository: MemberRepository.sharedInstance(
                MemberRemoteDataSource.sharedInstance(CredentialRepository()),
                MemberDraftLocalDataSource.sharedInstance
            )
        )
    )
}

//
//  MemberRepository.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import Foundation
import Combine

protocol MemberRepositoryProtocol {
    func getUploadedMembers() -> AnyPublisher<[MemberResponse], Error>
    func uploadMember(request: UploadMemberRequestModel) -> AnyPublisher<UploadMemberResponse, Error>
    func saveDraft(_ draft: MemberDraftModel)
    func getDrafts() -> [MemberDraftModel]
    func deleteDraft(id: String)
}

final class MemberRepository: MemberRepositoryProtocol {
    typealias MemberInstance = (MemberRemoteDataSourceProtocol, MemberDraftLocalDataSourceProtocol) -> MemberRepository

    private let remoteDataSource: MemberRemoteDataSourceProtocol
    private let localDataSource: MemberDraftLocalDataSourceProtocol

    private init(remote: MemberRemoteDataSourceProtocol, local: MemberDraftLocalDataSourceProtocol) {
        self.remoteDataSource = remote
        self.localDataSource = local
    }

    static let sharedInstance: MemberInstance = { remote, local in
        MemberRepository(remote: remote, local: local)
    }

    func getUploadedMembers() -> AnyPublisher<[MemberResponse], Error> {
        remoteDataSource.getUploadedMembers()
    }

    func uploadMember(request: UploadMemberRequestModel) -> AnyPublisher<UploadMemberResponse, Error> {
        remoteDataSource.uploadMember(request: request)
    }

    func saveDraft(_ draft: MemberDraftModel) {
        localDataSource.saveDraft(draft)
    }

    func getDrafts() -> [MemberDraftModel] {
        localDataSource.getDrafts()
    }

    func deleteDraft(id: String) {
        localDataSource.deleteDraft(id: id)
    }
}


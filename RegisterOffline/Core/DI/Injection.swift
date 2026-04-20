//
//  Injection.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

final class Injection {

    func makeCredentialRepository() -> CredentialRepositoryProtocol {
        CredentialRepository()
    }

    func provideLogin() -> LoginRepositoryProtocol {
        let credentialRepository = makeCredentialRepository()
        let remoteDataSource = LoginRemoteDataSource.sharedInstance(credentialRepository)
        return LoginRepository.sharedInstance(remoteDataSource)
    }

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(repository: provideLogin())
    }

    func provideRegister() -> RegisterRepositoryProtocol {
        let remoteDataSource = RegisterRemoteDataSource.sharedInstance
        return RegisterRepository.sharedInstance(remoteDataSource)
    }

    func makeRegisterViewModel() -> RegisterViewModel {
        RegisterViewModel(repository: provideRegister())
    }

    func provideProfile() -> ProfileRepositoryProtocol {
        let credentialRepository = makeCredentialRepository()
        let remoteDataSource = ProfileRemoteDataSource.sharedInstance(credentialRepository)
        return ProfileRepository.sharedInstance(remoteDataSource)
    }

    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(repository: provideProfile())
    }

    func provideMember() -> MemberRepositoryProtocol {
        let credentialRepository = makeCredentialRepository()
        let remoteDataSource = MemberRemoteDataSource.sharedInstance(credentialRepository)
        let localDataSource = MemberDraftLocalDataSource.sharedInstance
        return MemberRepository.sharedInstance(remoteDataSource, localDataSource)
    }

    func makeDocumentViewModel() -> DocumentViewModel {
        DocumentViewModel(repository: provideMember())
    }

    func makeCreateDocumentViewModel() -> CreateDocumentViewModel {
        CreateDocumentViewModel(repository: provideMember())
    }
}

//
//  MemberRemoteDataSource.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON

protocol MemberRemoteDataSourceProtocol: AnyObject {
    func getUploadedMembers() -> AnyPublisher<[MemberResponse], Error>
    func uploadMember(request: UploadMemberRequestModel) -> AnyPublisher<UploadMemberResponse, Error>
}

final class MemberRemoteDataSource: NSObject {
    private let keychainRepository: CredentialRepositoryProtocol

    static func sharedInstance(_ keychainRepository: CredentialRepositoryProtocol) -> MemberRemoteDataSource {
        MemberRemoteDataSource(keychainRepository: keychainRepository)
    }

    private init(keychainRepository: CredentialRepositoryProtocol) {
        self.keychainRepository = keychainRepository
        super.init()
    }
}

extension MemberRemoteDataSource: MemberRemoteDataSourceProtocol {
    func getUploadedMembers() -> AnyPublisher<[MemberResponse], Error> {
        let endpoint = Endpoints.Gets.member
        let url = endpoint.url
        let headers = APICall.makeHeaders(
            bearerToken: keychainRepository.getToken(),
            contentType: "application/json"
        )

        return Future<[MemberResponse], Error> { completion in
            AF.request(url, method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let responseData = JSON(data)
                    let items = responseData.arrayValue
                    let members = items.map { MemberResponse(json: $0) }

                    completion(.success(members))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func uploadMember(request: UploadMemberRequestModel) -> AnyPublisher<UploadMemberResponse, Error> {
        let endpoint = Endpoints.Gets.member
        let url = endpoint.url
        let headers = APICall.makeHeaders(bearerToken: keychainRepository.getToken())

        return Future<UploadMemberResponse, Error> { completion in
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(Data(request.name.utf8), withName: "name")
                    multipartFormData.append(Data(request.nik.utf8), withName: "nik")
                    multipartFormData.append(Data(request.phone.utf8), withName: "phone")
                    multipartFormData.append(Data(request.birthPlace.utf8), withName: "birth_place")
                    multipartFormData.append(Data(request.birthDate.utf8), withName: "birth_date")
                    multipartFormData.append(Data(request.status.utf8), withName: "status")
                    multipartFormData.append(Data(request.occupation.utf8), withName: "occupation")
                    multipartFormData.append(Data(request.address.utf8), withName: "address")
                    multipartFormData.append(Data(request.provinsi.utf8), withName: "provinsi")
                    multipartFormData.append(Data(request.kotaKabupaten.utf8), withName: "kota_kabupaten")
                    multipartFormData.append(Data(request.kecamatan.utf8), withName: "kecamatan")
                    multipartFormData.append(Data(request.kelurahan.utf8), withName: "kelurahan")
                    multipartFormData.append(Data(request.kodePos.utf8), withName: "kode_pos")
                    multipartFormData.append(Data(request.alamatDomisili.utf8), withName: "alamat_domisili")
                    multipartFormData.append(Data(request.provinsiDomisili.utf8), withName: "provinsi_domisili")
                    multipartFormData.append(Data(request.kotaKabupatenDomisili.utf8), withName: "kota_kabupaten_domisili")
                    multipartFormData.append(Data(request.kecamatanDomisili.utf8), withName: "kecamatan_domisili")
                    multipartFormData.append(Data(request.kelurahanDomisili.utf8), withName: "kelurahan_domisili")
                    multipartFormData.append(Data(request.kodePosDomisili.utf8), withName: "kode_pos_domisili")
                    multipartFormData.append(request.primaryImageData, withName: "ktp_file", fileName: "ktp_primary.jpg", mimeType: "image/jpeg")
                    multipartFormData.append(request.secondaryImageData, withName: "ktp_file_secondary", fileName: "ktp_secondary.jpg", mimeType: "image/jpeg")
                },
                to: url,
                method: .post,
                headers: headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let responseData = JSON(data)
                    let uploadResponse = UploadMemberResponse(json: responseData)
                    completion(.success(uploadResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

//
//  AuthManager.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/21.
//

import Alamofire
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import RxSwift

struct APIError: Error {
    let statusCode: Int
    let description: String
}

class AuthManager {
    private init() {}

    public static let shared = AuthManager()
    static let uri = "https://"
    static let headers: HTTPHeaders = [
        "Authorization": "some auth",
        "Accept": "application/json",
        // TODO: Token
    ]

    // MARK: kakao
    // TODO: 로그인 후 User.me? 에서 userId 받은 후 우리 서버 로그인 API 호출?

    func kakaoSignin() -> Single<Result<String, APIError>> {
        return Single.create { single in
            if AuthApi.hasToken() { // 기존 access token 토큰 존재 여부 체크
                UserApi.shared.accessTokenInfo { _, error in // access token 토큰 요청
                    if error != nil { // access token 토큰 만료 시
                        if UserApi.isKakaoTalkLoginAvailable() { // 앱 로그인: 카톡 어플 O
                            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                                if error != nil { // 로그인 실패
                                    single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                } else { // 로그인 성공, userId 발급
                                    UserApi.shared.me(completion: { user, error in
                                        guard let user = user else {
                                            single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                            return
                                        }
                                        let id = "\(user.id)"
                                        single(.success(.success(id)))
                                    })
                                }
                            }
                        } else { // 웹 로그인: 카톡 어플 X
                            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                                if error != nil { // 로그인 실패
                                    single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                } else { // 로그인 성공, userId 발급
                                    UserApi.shared.me(completion: { user, error in
                                        guard let user = user else {
                                            single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                            return
                                        }
                                        let id = "\(user.id)"
                                        single(.success(.success(id)))
                                    })
                                }
                            }
                        }
                    } else { // 토큰 유효 시, userId 발급
                        UserApi.shared.me(completion: { user, errㅐㄱ in
                            guard let user = user else {
                                single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                return
                            }
                            let id = "\(user.id)"
                            single(.success(.success(id)))
                        })
                    }
                }
            } else { // 토큰 없을 시
                if UserApi.isKakaoTalkLoginAvailable() { // 간편 로그인: 카톡 어플 있을 시
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        if error != nil { // 로그인 실패
                            single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                        } else { // 로그인 성공, userId 발급
                            UserApi.shared.me(completion: { user, error in
                                guard let user = user else {
                                    single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                    return
                                }
                                let id = "\(user.id)"
                                single(.success(.success(id)))
                            })
                        }
                    }
                } else { // 카톡 어플 없을 시
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        if error != nil {
                            single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                        } else { // 로그인 성공, userId 발급
                            UserApi.shared.me(completion: { user, error in
                                guard let user = user else {
                                    single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                    return
                                }
                                let id = "\(user.id)"
                                single(.success(.success(id)))
                            })
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }

    func signin(authModel: AuthModel) -> Single<Result<UserModel, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/auth/signin") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            
            let str = """
            {
                "id": 1,
                "name": "김범수",
                "profileImageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9",
                "reviewCount": 12
            }
            """

            do {
                let model = try JSONDecoder().decode(UserModel.self, from: Data(str.utf8))
                single(.success(.success(model)))
            } catch {
                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
            }
            
            
            
            
            
//            single(.success(.success(())))
            // TODO: 401 리턴 시 회원가입
            single(.success(.failure(APIError(statusCode: 401, description: "unathorized"))))

//            guard let email = authModel.email,
//                  let password = authModel.password
//            else {
//                single(.success(.failure(APIError(statusCode: -1, description: "parameter error"))))
//                return Disposables.create()
//            }
//
//            let parameters = [
//                "email": email,
//                "password": password,
//            ]
//
//            AF
//                .request(url, method: .post, parameters: parameters, headers: AuthManager.shared.headers)
//                .validate(statusCode: 200 ..< 300)
//                .responseJSON(completionHandler: { response in
//                    switch response.result {
//                    case let .success(value):
//                        let json = JSON(value)
//                        guard let token = json["token"].string else {
//                            single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
//                            return
//                        }
//                        single(.success(.success(token)))
//                    case let .failure(error):
//                        guard let statusCode = response.response?.statusCode else {
//                            single(.success(.failure(APIError(statusCode: -1, description: "status code error"))))
//                            return
//                        }
//                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription ?? ""))))
//                    }
//                })
//                .resume()
//
            return Disposables.create()
        }
    }

    func signup(authModel: AuthModel) -> Single<Result<UserModel, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/auth/signup") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            
            let str = """
            {
                "id": 1,
                "name": "김범수",
                "profileImageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9",
                "reviewCount": 12
            }
            """

            do {
                let model = try JSONDecoder().decode(UserModel.self, from: Data(str.utf8))
                single(.success(.success(model)))
            } catch {
                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
            }
            
            return Disposables.create()
        }
    }

    func withdraw() -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/auth/signin") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            print("withdraw")
            single(.success(.success(())))
            return Disposables.create()
        }
    }

    func putProfileImage(name _: String, image _: UIImage?) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/auth/signin") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            print("putProfileImage")
            single(.success(.success(())))
            return Disposables.create()
        }
    }
}

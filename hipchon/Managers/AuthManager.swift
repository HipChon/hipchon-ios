//
//  AuthManager.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/21.
//

import Alamofire
import KakaoSDKCommon
import KakaoSDKAuth
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
    func kakaoSignup() -> Single<Result<String?, APIError>> {
        return Single.create { single in
            if AuthApi.hasToken() { // 토큰 있을 시
                UserApi.shared.accessTokenInfo { accessToken, error in
                    if accessToken == nil { // 토큰 만료 시
                        if UserApi.isKakaoTalkLoginAvailable() { // 간편 로그인: 카톡 어플 있을 시
                            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                                if error != nil {  // 로그인 실패
                                    single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                } else {    // 로그인 성공
                                    single(.success(.success(oauthToken?.accessToken)))
                                }
                            }
                        } else { // 카톡 어플 없을 시
                            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                                if error != nil {
                                    single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                                } else {
                                    single(.success(.success(oauthToken?.accessToken)))
                                }
                            }
                        }
                    } else { // 토큰 유효 시
                        single(.success(.success(""))) //TODO: accessToken
                    }
                }
            } else { // 토큰 없을 시
                if UserApi.isKakaoTalkLoginAvailable() { // 간편 로그인: 카톡 어플 있을 시
                    UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                        if error != nil {  // 로그인 실패
                            single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                        } else {    // 로그인 성공
                            single(.success(.success(oauthToken?.accessToken)))
                        }
                    }
                } else { // 카톡 어플 없을 시
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        if error != nil {
                            single(.success(.failure(APIError(statusCode: -1, description: error.debugDescription))))
                        } else {
                            single(.success(.success(oauthToken?.accessToken)))
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func signin(token: String) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/auth/signin") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            single(.success(.success(())))
//            single(.failure(APIError(statusCode: -1, description: "")))
            
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
    
    func signup(auth: AuthModel) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/auth/signin") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            single(.success(.success(())))
            return Disposables.create()
        }
    }
    
    func putProfileImage(image: UIImage) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/auth/signin") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            single(.success(.success(())))
            return Disposables.create()
        }
    }
}

//
//  ReviewAPI.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/27.
//

import Alamofire
import RxCocoa
import RxSwift
import SwiftKeychainWrapper
import SwiftyJSON

class ReviewAPI {
    private init() {}
    public static let shared = ReviewAPI()
    private let bag = DisposeBag()

    func getFeedReviews() -> Single<Result<[ReviewModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/post/all/\(APIParameters.shared.userId)/recently") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }
            print("getFeedReviews")

            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode([ReviewModel].self, from: data)
                                single(.success(.success(model)))
                            } catch {
                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                            }
                        }
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }

    func getPlaceReview(_ id: Int) -> Single<Result<[ReviewModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/post/place/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }
            print("getPlaceReview", id)

            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode([ReviewModel].self, from: data)
                                single(.success(.success(model)))
                            } catch {
                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                            }
                        }
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }

    func getMyReviews(_ type: ProfileReviewType) -> Single<Result<[ReviewModel], APIError>> {
        return Single.create { single in

            print("getMyReviews")
            let filter = type == .myReview ? "/post/user" : "/mypost"

            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api\(filter)/\(APIParameters.shared.userId)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode([ReviewModel].self, from: data)
                                single(.success(.success(model)))
                            } catch {
                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                            }
                        }
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }

    func getBestReview() -> Single<Result<[BestReviewModel], APIError>> {
        return Single.create { single in

            print("getBestReview")

            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/post/best") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode([BestReviewModel].self, from: data)
                                single(.success(.success(model)))
                            } catch {
                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                            }
                        }
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }


    func getReviewDetail(_ id: Int) -> Single<Result<ReviewModel, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/post/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            print("getReviewDetail")

            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode(ReviewModel.self, from: data)
                                single(.success(.success(model)))
                            } catch {
                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                            }
                        }
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }

    // MARK: Like

    func addLike(_ id: Int) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/mypost/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            print("addLike")

            APIParameters.shared.session
                .request(url, method: .post, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .response(completionHandler: { response in
                    switch response.result {
                    case .success:
                        single(.success(.success(())))
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }

    func deleteLike(_ id: Int) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/mypost/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            print("deleteLikea")

            APIParameters.shared.session
                .request(url, method: .delete, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .response(completionHandler: { response in
                    switch response.result {
                    case .success:
                        single(.success(.success(())))
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }
    
    // MARK: post review
    
    func postReview(placeId: Int, images: [UIImage], content: String, keywords: [KeywordModel]) -> Single<Result<Void, APIError>> {
        return Single.create { single in
          
            print("postReview")
            
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/post") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            
            let header: HTTPHeaders = [
                "Accept": "application/json",
                "Content-Type": "application/json",
            ]
            
            let parameters: [String : Any] = [
                "detail": content,
                "keywordIdList": keywords.compactMap { $0.id },
                "placeId": placeId,
                "userId": Int(APIParameters.shared.userId) ?? -1,
            ]

            APIParameters.shared.session
                .upload(multipartFormData: { multipartFormData in
                    
                    images.forEach { image in
                        let imageData = image.jpegData(compressionQuality: 1.0)!
                        multipartFormData.append(imageData, withName: "file",
                                                 fileName: "\(Date().timeIntervalSince1970).png",
                                                 mimeType: "image/png")
                    }

                    if let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                        multipartFormData.append(data, withName: "post", mimeType: "application/json")
                    }
                    
                }, to: url, usingThreshold: UInt64.init(), method: .post, headers: header)
                .response(completionHandler: { response in
                    switch response.result {
                    case .success:
                        single(.success(.success(())))
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }
    
    func deleteReview(_ id: Int) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/post/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            print("deleteReview")

            APIParameters.shared.session
                .request(url, method: .delete, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .response(completionHandler: { response in
                    switch response.result {
                    case .success:
                        single(.success(.success(())))
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }

}

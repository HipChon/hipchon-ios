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
    public static let shared = ReviewAPI()

    static let hostUrl = "http://54.180.25.216/"
    let headers: HTTPHeaders = [
        "Authorization": "some auth",
        "Accept": "application/json",
        "token": KeychainWrapper.standard.string(forKey: "token") ?? "",
    ]
    
    let session: Session = {
      let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
      return Session(configuration: configuration)
    }()
    
    let bag = DisposeBag()

    func getFeedReviews() -> Single<Result<[ReviewModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(ReviewAPI.hostUrl)/api/post/all/1/recently") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }
            print("getFeedReviews")
            
            self.session
                .request(url, method: .get, parameters: nil, headers: ReviewAPI.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let modelData = try JSON(data)["data"].rawData()
                            do {
                                let model = try JSONDecoder().decode([ReviewModel].self, from: modelData)
                                single(.success(.success(model)))
                            } catch {
                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                            }
                            
                        } catch {
                            single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                        }
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription ?? ""))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription ?? ""))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }
    
    func getPlaceReview(_ id: Int) -> Single<Result<[ReviewModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(ReviewAPI.hostUrl)/api/post/place/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }
            print("getPlaceReview", id)
            
            self.session
                .request(url, method: .get, parameters: nil, headers: ReviewAPI.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let modelData = try JSON(data)["data"].rawData()
                            do {
                                let model = try JSONDecoder().decode([ReviewModel].self, from: modelData)
                                single(.success(.success(model)))
                            } catch {
                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                            }
                            
                        } catch {
                            single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                        }
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription ?? ""))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription ?? ""))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }
    
    func getMyReviews(_ type: ProfileReviewType) -> Single<Result<[ReviewModel], APIError>> {
        return Single.create { single in

            print("getMyReviews")
            
            let urlStr = type == .myReview ? "\(ReviewAPI.hostUrl)/api/post/user/1" : "\(ReviewAPI.hostUrl)/api/mypost/1"
           
            guard let url = URL(string: urlStr) else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }
            
            self.session
                .request(url, method: .get, parameters: nil, headers: ReviewAPI.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let modelData = try JSON(data)["data"].rawData()
                            do {
                                let model = try JSONDecoder().decode([ReviewModel].self, from: modelData)
                                single(.success(.success(model)))
                            } catch {
                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                            }
                            
                        } catch {
                            single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                        }
                    case let .failure(error):
                        guard let statusCode = response.response?.statusCode else {
                            single(.success(.failure(APIError(statusCode: error._code,
                                                              description: error.errorDescription ?? ""))))
                            return
                        }
                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription ?? ""))))
                    }
                })
                .resume()

            return Disposables.create()
        }
    }
    
}

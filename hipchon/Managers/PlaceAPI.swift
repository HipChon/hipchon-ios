//
//  PlaceAPI.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/27.
//

import Alamofire
import RxCocoa
import RxSwift
import SwiftKeychainWrapper
import SwiftyJSON

class PlaceAPI {
    private init() {}
    
    public static let shared = PlaceAPI()
    private let bag = DisposeBag()

    func getPlaceList(filter: SearchFilterModel, sort: SortType) -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            print("getPlaceList")
            var urlStr = "\(APIParameters.shared.hostUrl)/api/place/\(APIParameters.shared.userId)"
            
            if filter.hashtag == nil {
                if let regionId = filter.region?.id {
                    urlStr += "/\(regionId)"
                }
                
                if let categoryId = filter.category?.id {
                    urlStr += "/\(categoryId)"
                }
                
                if sort == .bookmark {
                    urlStr += "/myplace"
                } else {
                    urlStr += "/review"
                }
                
            } else if let hashtagId = filter.hashtag?.id,
                      let order = sort == .bookmark ? "myplace" : "review" {
                urlStr = "\(APIParameters.shared.hostUrl)/api/place/hashtag/\(APIParameters.shared.userId)/\(hashtagId)/\(order)"
            } else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
            }
            
            guard let url = URL(string: urlStr) else {
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
                                let model = try JSONDecoder().decode([PlaceModel].self, from: data)
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

    func getWeeklyHipPlace() -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/place/hiple/\(APIParameters.shared.userId)") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getWeeklyHipPlace")
            
            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode([PlaceModel].self, from: data)
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
    
    func getPlaceDetail(_ id: Int) -> Single<Result<PlaceModel, APIError>>  {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/place/\(APIParameters.shared.userId)/\(id)") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getPlaceDetail")
            
            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode(PlaceModel.self, from: data)
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
    
    func getMyPlaces(_ sector: SectorType) -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/myplace/\(APIParameters.shared.userId)") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getMyPlaces \(sector)")
            
            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode([PlaceModel].self, from: data)
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
}
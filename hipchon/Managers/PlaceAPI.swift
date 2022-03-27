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
    public static let shared = PlaceAPI()

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

    func getPlaceList(filter: SearchFilterModel, sort: SortType) -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            print("getPlaceList")
            var urlStr = ""
            
            if filter.hashtag == nil,
               let regionId = filter.region?.id,
               let categoryId = filter.category?.id,
               let order = sort == .bookmark ? "myplace" : "review" {
                urlStr = "\(PlaceAPI.hostUrl)/api/place/1/\(regionId)/\(categoryId)/\(order)"
            } else if let hashtagId = filter.hashtag?.id,
                      let order = sort == .bookmark ? "myplace" : "review" {
                urlStr = "\(PlaceAPI.hostUrl)/api/place/hashtag/1/\(hashtagId)/\(order)"
            } else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
            }
            
            guard let url = URL(string: urlStr) else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            
            
            self.session
                .request(url, method: .get, parameters: nil, headers: PlaceAPI.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let modelData = try JSON(data)["data"].rawData()
                            do {
                                let model = try JSONDecoder().decode([PlaceModel].self, from: modelData)
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

    func getWeeklyHipPlace() -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(PlaceAPI.hostUrl)/api/place/hiple/1") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getWeeklyHipPlace")
            
            self.session
                .request(url, method: .get, parameters: nil, headers: PlaceAPI.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let modelData = try JSON(data)["data"].rawData()
                            do {
                                let model = try JSONDecoder().decode([PlaceModel].self, from: modelData)
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
    
    func getPlaceDetail(_ id: Int) -> Single<Result<PlaceModel, APIError>>  {
        return Single.create { single in
            guard let url = URL(string: "\(PlaceAPI.hostUrl)/api/place/1/\(id)") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getPlaceDetail")
            
            self.session
                .request(url, method: .get, parameters: nil, headers: PlaceAPI.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let modelData = try JSON(data)["data"].rawData()
                            do {
                                let model = try JSONDecoder().decode(PlaceModel.self, from: modelData)
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
    
    func getMyPlaces(_ sector: SectorType) -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(PlaceAPI.hostUrl)/api/myplace/1") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getMyPlaces \(sector)")
            
            self.session
                .request(url, method: .get, parameters: nil, headers: PlaceAPI.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let modelData = try JSON(data)["data"].rawData()
                            do {
                                let model = try JSONDecoder().decode([PlaceModel].self, from: modelData)
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

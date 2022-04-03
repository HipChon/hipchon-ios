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
            let order = sort == .bookmark ? "myplace" : "review"

            if filter.hashtag == nil {
                urlStr = "\(APIParameters.shared.hostUrl)/api/place/\(APIParameters.shared.userId)/\(filter.region?.id ?? -1)/\(filter.category?.id ?? -1)/\(order)"
            } else if let hashtagId = filter.hashtag?.id {
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
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
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

    func getPlaceDetail(_ id: Int) -> Single<Result<PlaceModel, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/place/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
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

    func getMyPlaces(_ category: CategoryModel) -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            
            
            var urlStr = "\(APIParameters.shared.hostUrl)/api/myplace/\(APIParameters.shared.userId)"
            
            if let id = category.id {
                urlStr.append("/\(id)")
            }

            guard let url = URL(string: urlStr) else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }
            print("getMyPlaces \(category.name)")

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

    // MARK: local hipster

    func getLocalHipsterPickList() -> Single<Result<[LocalHipsterPickModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/hipster") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }
            print("getLocalHipsterPickList")

            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode([LocalHipsterPickModel].self, from: data)
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

    func getLocalHipsterPickDetail(id: Int) -> Single<Result<LocalHipsterPickModel, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/hipster/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            print("getLocalHipsterPickDetail")

            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode(LocalHipsterPickModel.self, from: data)
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

    // MARK: Bookmark

    func addBookmark(_ id: Int) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/myplace/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            print("addBookmark")

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

    func deleteBookmark(_ id: Int) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/myplace/\(APIParameters.shared.userId)/\(id)") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            print("deleteBookmark")

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
    
    func postMemo(placeId: Int, memo: MemoModel) -> Single<Result<Void, APIError>> {
        return Single.create { single in
            guard let content = memo.content,
                  let color = memo.color else {
                      single(.success(.failure(APIError(statusCode: -1, description: "parameters error"))))
                      return Disposables.create()
                  }
            
            guard let url = URL(string: "\(NetworkManager.uri)/api/Like") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            print("postMemo")

            UserDefaults.standard.set(content, forKey: "\(placeId)Content")
            UserDefaults.standard.set(color, forKey: "\(placeId)Color")

            single(.success(.success(())))

            return Disposables.create()
        }
    }
}

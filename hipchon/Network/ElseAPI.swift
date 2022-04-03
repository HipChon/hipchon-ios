//
//  ElseAPI.swift
//  hipchon
//
//  Created by 김범수 on 2022/04/02.
//

import Alamofire
import RxCocoa
import RxSwift
import SwiftKeychainWrapper
import SwiftyJSON

class ElseAPI {
    private init() {}
    public static let shared = ElseAPI()
    private let bag = DisposeBag()

    func getBanners() -> Single<Result<[BannerModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(APIParameters.shared.hostUrl)/api/event") else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }
            print("getBanners")

            APIParameters.shared.session
                .request(url, method: .get, parameters: nil, headers: APIParameters.shared.headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            do {
                                let model = try JSONDecoder().decode([BannerModel].self, from: data)
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

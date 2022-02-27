//
//  NetworkManager.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/14.
//

import Alamofire
import RxCocoa
import RxSwift

enum NetworkError: Error {
    case uri, parsing
}

class NetworkManager {
    private init() {}

    public static let shared = NetworkManager()
    static let uri = "https://"
    static let headers: HTTPHeaders = [
        "Authorization": "some auth",
        "Accept": "application/json",
    ]

    func getReviews() -> Single<[ReviewModel]> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/eco") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }

//            AF
//                .request(url, method: .get, parameters: nil, headers: NetworkManager.headers)
//                .responseJSON(completionHandler: { response in
//                    switch response.result {
//                    case .success:
//                        if let data = response.data {
//                            do {
//                                let model = try JSONDecoder().decode([ReviewModel].self, from: data)
//                                single(.success(model))
//                            } catch {
//                                single(.failure(NetworkError.parsing))
//                            }
//                        }
//                    case let .failure(error):
//                        single(.failure(error))
//                    }
//                })
//                .resume()

            let str = """
            [
                {
                    "id": 1,
                    "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                    "postDt": "2022-01-01-24-00-00",
                    "imageURLs": [
            "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F1?alt=media&token=b73a9623-b2be-4e2f-87bc-6b0f7b4a6a95", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F2?alt=media&token=dd211d8a-de72-4802-80b8-83237994318a", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    ],
                    "user": {
                        "id": 1,
                        "name": "김범수",
                        "profileImageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    },
                    "place": {
                        "id": 1,
                        "name": "러스틱 카페",
                        "address": "서울특별시 용산구 서빙고",
                        "category": "맛집"
                    }
                },
                {
                    "id": 1,
                    "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                    "postDt": "2022-01-01-24-00-00",
                    "imageURLs": [
            "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F1?alt=media&token=b73a9623-b2be-4e2f-87bc-6b0f7b4a6a95", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F2?alt=media&token=dd211d8a-de72-4802-80b8-83237994318a", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    ],
                    "user": {
                        "id": 1,
                        "name": "김범수",
                        "profileImageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    },
                    "place": {
                        "id": 1,
                        "name": "러스틱 카페",
                        "address": "서울특별시 용산구 서빙고",
                        "category": "맛집"
                    }
                },
                {
                    "id": 1,
                    "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                    "postDt": "2022-01-01-24-00-00",
                    "imageURLs": [
            "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F1?alt=media&token=b73a9623-b2be-4e2f-87bc-6b0f7b4a6a95", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F2?alt=media&token=dd211d8a-de72-4802-80b8-83237994318a", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    ],
                    "user": {
                        "id": 1,
                        "name": "김범수",
                        "profileImageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    },
                    "place": {
                        "id": 1,
                        "name": "러스틱 카페",
                        "address": "서울특별시 용산구 서빙고",
                        "category": "맛집"
                    }
                }
            ]
            """

            do {
                let model = try JSONDecoder().decode([ReviewModel].self, from: Data(str.utf8))
                single(.success(model))
            } catch {
                single(.failure(NetworkError.parsing))
            }

            return Disposables.create()
        }
    }

    func getPlaces() -> Single<[PlaceModel]> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/eco") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }

            let str = """
            [
                {
                    "id": 1,
                    "name": "옹심이네",
                    "region": "서울",
                    "price": 100000.0,
                    "imageURLs": [
            "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F1?alt=media&token=b73a9623-b2be-4e2f-87bc-6b0f7b4a6a95", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F2?alt=media&token=dd211d8a-de72-4802-80b8-83237994318a", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    ],
                    "hashtags": ["3인가능", "반려동물", "핫플"],
                    "bookmarkCount": 32,
                    "reviewCount": 12
                },
                 {
                     "id": 1,
                     "name": "옹심이네",
                     "region": "서울",
                     "price": 100000.0,
                     "imageURLs": [
             "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F1?alt=media&token=b73a9623-b2be-4e2f-87bc-6b0f7b4a6a95", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F2?alt=media&token=dd211d8a-de72-4802-80b8-83237994318a", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                     ],
                     "hashtags": ["3인가능", "반려동물", "핫플"],
                     "bookmarkCount": 32,
                     "reviewCount": 12
                 },

            ]

            """

            do {
                let model = try JSONDecoder().decode([PlaceModel].self, from: Data(str.utf8))
                single(.success(model))
            } catch {
                single(.failure(NetworkError.parsing))
            }

            return Disposables.create()
        }
    }
}

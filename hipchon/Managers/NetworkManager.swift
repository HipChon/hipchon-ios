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
    
    // MARK: Home
    
    func getHipsterPick() -> Single<[HipsterPickModel]> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/hipsteropick") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }

            let str = """
            [
                {
                    "id": 1,
                    "region": "제주",
                    "title": "제주의 맛맛맛",
                    "content": "제주 해녀의 부억 5곳 외",
                    "imageURL": "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fcd80fd32-d1cd-4788-b805-b4a0e6f8d93d%2FUntitled.png?table=block&id=174817c5-00c5-43cc-be70-4473d98a7fa5&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=1380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                },
                {
                    "id": 1,
                    "region": "제주",
                    "title": "제주의 맛맛맛",
                    "content": "제주 해녀의 부억 5곳 외",
                    "imageURL": "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fcd80fd32-d1cd-4788-b805-b4a0e6f8d93d%2FUntitled.png?table=block&id=174817c5-00c5-43cc-be70-4473d98a7fa5&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=1380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                },
                {
                    "id": 1,
                    "region": "제주",
                    "title": "제주의 맛맛맛",
                    "content": "제주 해녀의 부억 5곳 외",
                    "imageURL": "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fcd80fd32-d1cd-4788-b805-b4a0e6f8d93d%2FUntitled.png?table=block&id=174817c5-00c5-43cc-be70-4473d98a7fa5&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=1380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                }
            ]
            """

            do {
                let model = try JSONDecoder().decode([HipsterPickModel].self, from: Data(str.utf8))
                single(.success(model))
            } catch {
                single(.failure(NetworkError.parsing))
            }

            return Disposables.create()
        }
    }
    
    func getBestReview() -> Single<[BestReviewModel]> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/bestReviews") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }

            let str = """
            [
                {
                    "id": 0,
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F9730533f-b629-48b2-a0a8-5123f59071bd%2FGroup_271_(1).png?table=block&id=aa968ad4-7505-4054-bd92-f0665958380c&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                },
                {
                    "id": 0,
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F9730533f-b629-48b2-a0a8-5123f59071bd%2FGroup_271_(1).png?table=block&id=aa968ad4-7505-4054-bd92-f0665958380c&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                },
                {
                    "id": 0,
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F9730533f-b629-48b2-a0a8-5123f59071bd%2FGroup_271_(1).png?table=block&id=aa968ad4-7505-4054-bd92-f0665958380c&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                }
            ]

            """

            do {
                let model = try JSONDecoder().decode([BestReviewModel].self, from: Data(str.utf8))
                single(.success(model))
            } catch {
                single(.failure(NetworkError.parsing))
            }

            return Disposables.create()
        }
    }

    func getBanners() -> Single<[BannerModel]> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/banners") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }

            let str = """
            [
                {
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Faa717eb4-44db-4475-b54c-baaf01d30e60%2FUntitled.png?table=block&id=2e3d1560-ed3c-4767-8d9b-cb5d00199084&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                    "linkURL": "https://www.notion.so/Back-Log-fa4e8b10bbba4721b17be88a2eaf465a"
                },
                {
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Faa717eb4-44db-4475-b54c-baaf01d30e60%2FUntitled.png?table=block&id=2e3d1560-ed3c-4767-8d9b-cb5d00199084&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                    "linkURL": "https://www.notion.so/Back-Log-fa4e8b10bbba4721b17be88a2eaf465a"
                },
                {
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Faa717eb4-44db-4475-b54c-baaf01d30e60%2FUntitled.png?table=block&id=2e3d1560-ed3c-4767-8d9b-cb5d00199084&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                    "linkURL": "https://www.notion.so/Back-Log-fa4e8b10bbba4721b17be88a2eaf465a"
                }
            ]

            """

            do {
                let model = try JSONDecoder().decode([BannerModel].self, from: Data(str.utf8))
                single(.success(model))
            } catch {
                single(.failure(NetworkError.parsing))
            }

            return Disposables.create()
        }
    }
    
    func getWeeklyHipPlace() -> Single<[PlaceModel]> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/hipplace") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }

            let str = """
            [
                {
                    "id": 1,
                    "name": "힙플레이스",
                    "region": "강원도",
                    "bookmarkYn": true,
                    "distance": 150.4,
                    "price": 80000.0,
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F4a5dd5b0-e39c-4ca3-b0c1-3f767367c9ad%2FUntitled.png?table=block&id=dddf5931-e323-47a1-8ee8-fa7267ac1116&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=790&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                    ],
                    "hashtags": ["3인가능", "반려동물", "핫플"],
                    "bookmarkCount": 32,
                    "reviewCount": 12
                },
                {
                    "id": 1,
                    "name": "힙플레이스",
                    "region": "강원도",
                    "bookmarkYn": true,
                    "distance": 150.4,
                    "price": 80000.0,
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F4a5dd5b0-e39c-4ca3-b0c1-3f767367c9ad%2FUntitled.png?table=block&id=dddf5931-e323-47a1-8ee8-fa7267ac1116&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=790&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                    ],
                    "hashtags": ["3인가능", "반려동물", "핫플"],
                    "bookmarkCount": 32,
                    "reviewCount": 12
                },
                {
                    "id": 1,
                    "name": "힙플레이스",
                    "region": "강원도",
                    "bookmarkYn": true,
                    "distance": 150.4,
                    "price": 80000.0,
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F4a5dd5b0-e39c-4ca3-b0c1-3f767367c9ad%2FUntitled.png?table=block&id=dddf5931-e323-47a1-8ee8-fa7267ac1116&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=790&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                    ],
                    "hashtags": ["3인가능", "반려동물", "핫플"],
                    "bookmarkCount": 32,
                    "reviewCount": 12
                }
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
    
    // MARK: ?
    
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
                        "profileImageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9",
                        "reviewCount": 12
                    },
                    "place": {
                        "id": 1,
                        "name": "러스틱 카페",
                        "address": "서울특별시 용산구 서빙고",
                        "sector": "맛집",
                        "bookmarkYn": false
                    },
                    "likeCount": 23,
                    "commentCount": 12
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
                        "profileImageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9",
                        "reviewCount": 12
                    },
                    "place": {
                        "id": 1,
                        "name": "러스틱 카페",
                        "address": "서울특별시 용산구 서빙고",
                        "sector": "맛집",
                        "bookmarkYn": true
                    },
                    "likeCount": 23,
                    "commentCount": 12
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
                        "profileImageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9",
                        "reviewCount": 12
                    },
                    "place": {
                        "id": 1,
                        "name": "러스틱 카페",
                        "address": "서울특별시 용산구 서빙고",
                        "sector": "맛집",
                        "bookmarkYn": false
                    },
                    "likeCount": 23,
                    "commentCount": 12
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
                    "bookmarkYn": true,
                    "distance": 50.4,
                    "price": 100000.0,
                    "imageURLs": [
            "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F1?alt=media&token=b73a9623-b2be-4e2f-87bc-6b0f7b4a6a95", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F2?alt=media&token=dd211d8a-de72-4802-80b8-83237994318a", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    ],
                    "hashtags": ["3인가능", "반려동물", "핫플"],
                    "bookmarkCount": 32,
                    "reviewCount": 12,
                },
                 {
                     "id": 1,
                     "name": "옹심이네",
                     "region": "서울",
                     "bookmarkYn": false,
                     "distance": 50.4,
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
    
    // MARK: placeDetail
    
    func getPlaceDetail(_ id: Int) -> Single<PlaceModel> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/place/\(id)") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }

            let str = """
            {
                "id": 1,
                "name": "옹심이네",
                "region": "서울",
                "bookmarkYn": true,
                "distance": 50.4,
                "price": 100000.0,
                "imageURLs": [
                "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F1?alt=media&token=b73a9623-b2be-4e2f-87bc-6b0f7b4a6a95",
                "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F2?alt=media&token=dd211d8a-de72-4802-80b8-83237994318a", "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                ],
                "hashtags": ["3인가능", "반려동물", "핫플"],
                "bookmarkCount": 32,
                "reviewCount": 12,
                "sector": "카페/식당",
                "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
                "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
                "link": "http://www.naver.com",
                "geoLat": 37.27455854791513,
                "geoLon": 127.50946893739612,
                "address": "경기 고양시 일산동구 강송로 170 현대프라자",
                "number": "01073787605",
                "compliments": [
                    {
                        "content": "화장실이 청결해요",
                        "count": 35
                    },
                    {
                        "content": "단체모임 하기 좋아요",
                        "count": 31
                    },
                    {
                        "content": "여자/남자친구가 좋아해요",
                        "count": 28
                    }
                ]
            }
            """
    
            do {
                let model = try JSONDecoder().decode(PlaceModel.self, from: Data(str.utf8))
                single(.success(model))
            } catch {
                single(.failure(NetworkError.parsing))
            }

            return Disposables.create()
        }
    }
    
    // MARK: Bookmark

    func addBookmark(_ id: Int) -> Single<Bool> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/bookmarks") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            single(.success(true))
//            AF
//                .request(url, method: .post, parameters: nil, headers: NetworkManager.headers)
//                .validate(statusCode: 200 ..< 300)
//                .response(completionHandler: { response in
//                    switch response.result {
//                    case .success:
//                        single(.success(true))
//                    case .failure:
//                        single(.success(false))
//                    }
//                })
//                .resume()
            
            return Disposables.create()
        }
    }

    func deleteBookmark(_ id: Int) -> Single<Bool> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/bookmarks") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            single(.success(true))

            return Disposables.create()
        }
    }
}

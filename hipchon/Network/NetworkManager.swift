//
//  NetworkManager.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/14.
//

import Alamofire
import RxCocoa
import RxSwift
import SwiftKeychainWrapper
import SwiftyJSON

enum NetworkError: Error {
    case uri, parsing
}

class NetworkManager {
    public static let shared = NetworkManager()
    static let uri = "https://4481af16-a6f8-45cb-abed-fdeefd721a9f.mock.pstmn.io"
    static let localUrl = "http://54.180.25.216/"
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

    // MARK: User

    func getUser() -> Single<UserModel> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/user") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getUser")
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
                single(.success(model))
            } catch {
                single(.failure(NetworkError.parsing))
            }

            return Disposables.create()
        }
    }

    // MARK: Home

    func getLocalHipsterPicks() -> Single<[LocalHipsterPickModel]> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/localHipsteropick") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getLocalHipsterPicks")
            let str = """
            [
                {
                    "id": 1,
                    "region": "제주",
                    "title": "제주의 맛맛맛",
                    "subTitle": "제주 해녀의 부억 5곳 외",
                    "imageURL": "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fc9622447-fb9f-4b6e-80d7-dd56cbe3caf5%2Fimage_29.png?table=block&id=eda48d8f-f246-4e1c-86b4-6bd14dac7f88&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                },
                {
                    "id": 1,
                    "region": "제주",
                    "title": "제주의 맛맛맛",
                    "subTitle": "제주 해녀의 부억 5곳 외",
                    "imageURL": "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fc9622447-fb9f-4b6e-80d7-dd56cbe3caf5%2Fimage_29.png?table=block&id=eda48d8f-f246-4e1c-86b4-6bd14dac7f88&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                },
                {
                    "id": 1,
                    "region": "제주",
                    "title": "제주의 맛맛맛",
                    "subTitle": "제주 해녀의 부억 5곳 외",
                    "imageURL": "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fc9622447-fb9f-4b6e-80d7-dd56cbe3caf5%2Fimage_29.png?table=block&id=eda48d8f-f246-4e1c-86b4-6bd14dac7f88&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                }
            ]
            """

            do {
                let model = try JSONDecoder().decode([LocalHipsterPickModel].self, from: Data(str.utf8))
                single(.success(model))
            } catch {
                single(.failure(NetworkError.parsing))
            }

            return Disposables.create()
        }
    }

    func getHipsterPicks(_: Int) -> Single<[HipsterPickModel]> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/hipsteropicks") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("getHipsterPicks")
            let str = """
            [
                {
                    "id": 1,
                    "title": "첫번째. 해녀의 부엌",
                    "content": "공연과 이야기, 식사가 있는 국내 최초 <제주 해녀 다이닝> '해녀 이야기'는 90세 최고령 해녀, 권영희 할머니를 비롯하여 40년 넘게 물질해 온 해녀들을 직접 만나는 공연입니다. 해녀의 삶을 담은 연극 공연과 직접 잡아온 해산물로 만든 식사가 제공됩니다.",
                    "place": {
                        "id": 1,
                        "name": "해녀의 부억",
                        "region": "제주도",
                        "address": "제주특별자치도 서귀포시",
                        "sector": "음식점",
                        "bookmarkYn": true,
                        "distance": 50.4,
                        "price": 100000.0,
                        "imageURLs": [
                      "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fc9622447-fb9f-4b6e-80d7-dd56cbe3caf5%2Fimage_29.png?table=block&id=eda48d8f-f246-4e1c-86b4-6bd14dac7f88&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fc9622447-fb9f-4b6e-80d7-dd56cbe3caf5%2Fimage_29.png?table=block&id=eda48d8f-f246-4e1c-86b4-6bd14dac7f88&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fc9622447-fb9f-4b6e-80d7-dd56cbe3caf5%2Fimage_29.png?table=block&id=eda48d8f-f246-4e1c-86b4-6bd14dac7f88&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                        ]
                    }
                },
                {
                    "id": 1,
                    "title": "두번째. 말고기 연구소",
                    "content": "제주바다 보며 가볍게 즐기는 말고기. 제주에서만 맛볼 수 있는 말고기를 누구나 부담없이 맛있게 먹을 수 있도록 메뉴를 개발하고 연구합니다. 국내 최초 말고기 100%로 만든 독일식 수제 말고기 소시지부터 입안에서 사르르 녹아내리는 말고기 초밥을 판매하고 있습니다.",
                    "place": {
                        "id": 1,
                        "name": "말고기 연구소",
                        "region": "제주도",
                        "address": "제주특별자치도 서귀포시",
                        "sector": "음식점",
                        "bookmarkYn": true,
                        "distance": 50.4,
                        "price": 100000.0,
                        "imageURLs": [
                      "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fb02f5c02-0567-48a3-859c-2de39c5d28f7%2F%E1%84%86%E1%85%A1%E1%86%AF%E1%84%80%E1%85%A9%E1%84%80%E1%85%B5%E1%84%8B%E1%85%A7%E1%86%AB%E1%84%80%E1%85%AE%E1%84%89%E1%85%A91.png?table=block&id=1bb1be64-fb50-4f3b-99c6-1a155a11dab9&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                      "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fb02f5c02-0567-48a3-859c-2de39c5d28f7%2F%E1%84%86%E1%85%A1%E1%86%AF%E1%84%80%E1%85%A9%E1%84%80%E1%85%B5%E1%84%8B%E1%85%A7%E1%86%AB%E1%84%80%E1%85%AE%E1%84%89%E1%85%A91.png?table=block&id=1bb1be64-fb50-4f3b-99c6-1a155a11dab9&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                      "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2Fb02f5c02-0567-48a3-859c-2de39c5d28f7%2F%E1%84%86%E1%85%A1%E1%86%AF%E1%84%80%E1%85%A9%E1%84%80%E1%85%B5%E1%84%8B%E1%85%A7%E1%86%AB%E1%84%80%E1%85%AE%E1%84%89%E1%85%A91.png?table=block&id=1bb1be64-fb50-4f3b-99c6-1a155a11dab9&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                        ]
                    }
                },
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
            print("getBestReview")

            let str = """
            [
                {
                    "id": 0,
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F9730533f-b629-48b2-a0a8-5123f59071bd%2FGroup_271_(1).png?table=block&id=aa968ad4-7505-4054-bd92-f0665958380c&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                    "review": {
                        "id": 1,
                        "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                        "postDt": "2022-03-19T11:02:11.111",
                        "imageURLs": [
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                                    "bookmarkYn": false,
                                    "hashtag": {
                                        "name": "불멍",
                                        "imageURL":
                                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                                    }
                                },
                                "likeCount": 23,
                                "commentCount": 12,
                                "likeYn": true
                            }
                    },
                {
                    "id": 0,
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F9730533f-b629-48b2-a0a8-5123f59071bd%2FGroup_271_(1).png?table=block&id=aa968ad4-7505-4054-bd92-f0665958380c&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                    "review": {
                        "id": 1,
                        "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                        "postDt": "2022-03-19T11:02:11.111",
                        "imageURLs": [
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                                    "bookmarkYn": false,
                                    "hashtag": {
                                        "name": "불멍",
                                        "imageURL":
                                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                                    }
                                },
                                "likeCount": 23,
                                "commentCount": 12,
                                "likeYn": true
                            }
                    },
                {
                    "id": 0,
                    "imageURL":"https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F9730533f-b629-48b2-a0a8-5123f59071bd%2FGroup_271_(1).png?table=block&id=aa968ad4-7505-4054-bd92-f0665958380c&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                    "review": {
                        "id": 1,
                        "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                        "postDt": "2022-03-19T11:02:11.111",
                        "imageURLs": [
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                                    "bookmarkYn": false,
                                    "hashtag": {
                                        "name": "불멍",
                                        "imageURL":
                                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                                    }
                                },
                                "likeCount": 23,
                                "commentCount": 12,
                                "likeYn": true
                            }
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
            print("getBanners")
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
            print("getWeeklyHipPlace")
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
                    "keywords": [
                        {
                            "content": "화장실이 청결해요",
                            "count": 35
                        },
                        {
                            "content": "단체 모임 하기 좋아요",
                            "count": 31
                        },
                        {
                            "content": "직원분들이 친절해요",
                            "count": 28
                        }
                    ],
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
                    "keywords": [
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
                    ],
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
                      "keywords": [
                          {
                              "content": "화장실이 청결해요",
                              "count": 35
                          },
                          {
                              "content": "단체 모임 하기 좋아요",
                              "count": 31
                          },
                          {
                              "content": "직원분들이 친절해요",
                              "count": 28
                          }
                      ],
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
            print("getReviews")
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
                    "postDt": "2022-03-19T11:02:11.111",
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                        "bookmarkYn": false,
                        "hashtag": {
                            "name": "불멍",
                            "imageURL":
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                        }
                    },
                    "likeCount": 23,
                    "commentCount": 12,
                    "likeYn": true
                },
                {
                    "id": 1,
                    "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                    "postDt": "2022-03-19T11:02:11.111",
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                        "bookmarkYn": true,
                        "hashtag": {
                            "name": "불멍",
                            "imageURL":
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                        }
                    },
                    "likeCount": 23,
                    "commentCount": 12,
                    "likeYn": false
                },
                {
                    "id": 1,
                    "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                    "postDt": "2022-03-19T11:02:11.111",
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                        "bookmarkYn": false,
                        "hashtag": {
                            "name": "불멍",
                            "imageURL":
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                        }
                    },
                    "likeCount": 23,
                    "commentCount": 12,
                    "likeYn": true
                },
                {
                    "id": 1,
                    "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                    "postDt": "2022-03-19T11:02:11.111",
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                        "bookmarkYn": false,
                        "hashtag": {
                            "name": "불멍",
                            "imageURL":
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                        }
                    },
                    "likeCount": 23,
                    "commentCount": 12,
                    "likeYn": true
                },
                {
                    "id": 1,
                    "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                    "postDt": "2022-03-19T11:02:11.111",
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                        "bookmarkYn": true,
                        "hashtag": {
                            "name": "불멍",
                            "imageURL":
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                        }
                    },
                    "likeCount": 23,
                    "commentCount": 12,
                    "likeYn": false
                },
                {
                    "id": 1,
                    "content": "탁 트인 뷰를 보면서 간만에 힐링했습니다.",
                    "postDt": "2022-03-19T11:02:11.111",
                    "imageURLs": [
            "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",             "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F62c315d4-1c35-4b5d-b07d-238552d59886%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2022-02-26_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_3.39_1.png?table=block&id=a88d842e-a8e4-4075-b935-7fdb9d97dfe6&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
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
                        "bookmarkYn": false,
                        "hashtag": {
                            "name": "불멍",
                            "imageURL":
                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F6c1887f7-6e65-4b7a-9fe3-61228a4b925b%2FFrame.png?table=block&id=f632c3be-72ce-4394-956b-dd47787f7c97&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=380&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                        }
                    },
                    "likeCount": 23,
                    "commentCount": 12,
                    "likeYn": true
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

    func getPlaces() -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.localUrl)/api/myplace/1") else {
                single(.success(.failure(APIError(statusCode: -1, description: "uri error"))))
                return Disposables.create()
            }
            print("getPlaces")
//            self.session
//                .request(url, method: .get, parameters: nil, headers: NetworkManager.shared.headers)
//                .validate(statusCode: 200 ..< 300)
//                .responseJSON(completionHandler: { response in
//                    switch response.result {
//                    case .success(let data):
//
//                        do {
//                            let modelData = try JSON(data)["data"].rawData()
//
//                            do {
//                                let model = try JSONDecoder().decode([PlaceModel].self, from: modelData)
//                                single(.success(.success(model)))
//                            } catch {
//                                single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
//                            }
//
//                        } catch {
//                            single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
//                        }
//
//
//                    case let .failure(error):
//                        guard let statusCode = response.response?.statusCode else {
//                            single(.success(.failure(APIError(statusCode: error._code,
//                                                              description: error.errorDescription ?? ""))))
//                            return
//                        }
//                        single(.success(.failure(APIError(statusCode: statusCode, description: error.errorDescription ?? ""))))
//                    }
//                     })
//                   .resume()
                    
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
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                                        ],
                                        "bookmarkCount": 32,
                                        "reviewCount": 12,
                                        "sector": "카페",
                                        "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
                                        "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
                                        "link": "http://www.naver.com",
                                        "geoLat": 37.27455854791513,
                                        "geoLon": 127.50946893739612,
                                        "address": "경기 고양시 일산동구 강송로 170 현대프라자",
                                        "number": "01073787605",
                                        "keywords": [
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
                                        ],
                                        "memo": {
                                            "content": "빵, 과일 먹으러 갈 곳",
                                            "color": "green"
                                        }
                                    },
                                     {
                                         "id": 1,
                                         "name": "옹심이네",
                                         "region": "서울",
                                         "bookmarkYn": true,
                                         "distance": 50.4,
                                         "price": 100000.0,
                                        "imageURLs": [
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                                        ],
                                         "bookmarkCount": 32,
                                         "reviewCount": 12,
                                         "sector": "식당",
                                         "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
                                         "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
                                         "link": "http://www.naver.com",
                                         "geoLat": 37.27455854791513,
                                         "geoLon": 127.50946893739612,
                                         "address": "경기 고양시 일산동구 강송로 170 현대프라자",
                                         "number": "01073787605",
                                         "keywords": [
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
                                     },
                                     {
                                         "id": 1,
                                         "name": "옹심이네",
                                         "region": "서울",
                                         "bookmarkYn": true,
                                         "distance": 50.4,
                                         "price": 100000.0,
                                        "imageURLs": [
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                                        ],
                                         "bookmarkCount": 32,
                                         "reviewCount": 12,
                                         "sector": "활동",
                                         "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
                                         "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
                                         "link": "http://www.naver.com",
                                         "geoLat": 37.27455854791513,
                                         "geoLon": 127.50946893739612,
                                         "address": "경기 고양시 일산동구 강송로 170 현대프라자",
                                         "number": "01073787605",
                                         "keywords": [
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
                                     },
                                     {
                                         "id": 1,
                                         "name": "옹심이네",
                                         "region": "서울",
                                         "bookmarkYn": true,
                                         "distance": 50.4,
                                         "price": 100000.0,
                                        "imageURLs": [
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                                        "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                                        ],
                                         "bookmarkCount": 32,
                                         "reviewCount": 12,
                                         "sector": "자연",
                                         "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
                                         "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
                                         "link": "http://www.naver.com",
                                         "geoLat": 37.27455854791513,
                                         "geoLon": 127.50946893739612,
                                         "address": "경기 고양시 일산동구 강송로 170 현대프라자",
                                         "number": "01073787605",
                                         "keywords": [
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
                                
                                ]
                                
                                """
                    
                    do {
                        let model = try JSONDecoder().decode([PlaceModel].self, from: Data(str.utf8))
                        single(.success(.success(model)))
                    } catch {
                        single(.success(.failure(APIError(statusCode: -1, description: "parsing error"))))
                    }
      

            return Disposables.create()
        }
    }
 

    func getPlaceList(filter: SearchFilterModel, sort: SortType) -> Single<Result<[PlaceModel], APIError>> {
        return Single.create { single in
            print("getPlaceList")
            var urlStr = ""
            
            if filter.hashtag == nil,
               let regionId = filter.region?.id,
               let categoryId = filter.category?.id,
               let order = sort == .bookmark ? "myplace" : "review" {
                urlStr = "\(NetworkManager.localUrl)/api/place/1/\(regionId)/\(categoryId)/\(order)"
            } else if let hashtagId = filter.hashtag?.id,
                      let order = sort == .bookmark ? "myplace" : "review" {
                urlStr = "\(NetworkManager.localUrl)/api/place/hashtag/1/\(hashtagId)/\(order)"
            } else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
            }
            
            guard let url = URL(string: urlStr) else {
                single(.success(.failure(APIError(statusCode: -1, description: "url error"))))
                return Disposables.create()
            }

            
            
            self.session
                .request(url, method: .get, parameters: nil, headers: NetworkManager.shared.headers)
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
//
//            let str = """
//            [
//                {
//                    "id": 1,
//                    "name": "옹심이네옹심이네옹심이네옹심이네옹심이네옹심이네옹심이네옹심이네옹심이네옹심이네옹심이네옹심이네옹심이네",
//                    "region": "서울",
//                    "bookmarkYn": true,
//                    "distance": 50.4,
//                    "price": 100000.0,
//                    "imageURLs": [
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
//                    ],
//                    "bookmarkCount": 32,
//                    "reviewCount": 12,
//                    "sector": "카페",
//                    "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
//                    "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
//                    "link": "http://www.naver.com",
//                    "geoLat": 37.27455854791513,
//                    "geoLon": 127.50946893739612,
//                    "address": "경기 고양시 일산동구 강송로 170 현대프라자",
//                    "number": "01073787605",
//                    "keywords": [
//                        {
//                            "content": "화장실이 청결해요",
//                            "count": 35
//                        },
//                        {
//                            "content": "단체모임 하기 좋아요",
//                            "count": 31
//                        },
//                        {
//                            "content": "여자/남자친구가 좋아해요",
//                            "count": 28
//                        }
//                    ],
//                    "memo": {
//                        "content": "빵, 과일 먹으러 갈 곳",
//                        "color": "green"
//                    }
//                },
//                 {
//                     "id": 1,
//                     "name": "옹심이네",
//                     "region": "서울",
//                     "bookmarkYn": true,
//                     "distance": 50.4,
//                     "price": 100000.0,
//                    "imageURLs": [
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
//                    ],
//                     "bookmarkCount": 32,
//                     "reviewCount": 12,
//                     "sector": "식당",
//                     "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
//                     "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
//                     "link": "http://www.naver.com",
//                     "geoLat": 37.27455854791513,
//                     "geoLon": 127.50946893739612,
//                     "address": "경기 고양시 일산동구 강송로 170 현대프라자",
//                     "number": "01073787605",
//                     "keywords": [
//                         {
//                             "content": "화장실이 청결해요",
//                             "count": 35
//                         },
//                         {
//                             "content": "단체모임 하기 좋아요",
//                             "count": 31
//                         },
//                         {
//                             "content": "여자/남자친구가 좋아해요",
//                             "count": 28
//                         }
//                     ]
//                 },
//                 {
//                     "id": 1,
//                     "name": "옹심이네",
//                     "region": "서울",
//                     "bookmarkYn": true,
//                     "distance": 50.4,
//                     "price": 100000.0,
//                    "imageURLs": [
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
//                    ],
//                     "bookmarkCount": 32,
//                     "reviewCount": 12,
//                     "sector": "활동",
//                     "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
//                     "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
//                     "link": "http://www.naver.com",
//                     "geoLat": 37.27455854791513,
//                     "geoLon": 127.50946893739612,
//                     "address": "경기 고양시 일산동구 강송로 170 현대프라자",
//                     "number": "01073787605",
//                     "keywords": [
//                         {
//                             "content": "화장실이 청결해요",
//                             "count": 35
//                         },
//                         {
//                             "content": "단체모임 하기 좋아요",
//                             "count": 31
//                         },
//                         {
//                             "content": "여자/남자친구가 좋아해요",
//                             "count": 28
//                         }
//                     ]
//                 },
//                 {
//                     "id": 1,
//                     "name": "옹심이네",
//                     "region": "서울",
//                     "bookmarkYn": true,
//                     "distance": 50.4,
//                     "price": 100000.0,
//                    "imageURLs": [
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
//                    "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
//                    ],
//                     "bookmarkCount": 32,
//                     "reviewCount": 12,
//                     "sector": "자연",
//                     "businessHours": "11:00 - 19:00 (매주 월/화/수요일 휴무)",
//                     "description": "러스틱 라이프를 담은 브런치 신선한 재료와 평화로운 뷰가 자랑거리입니다.",
//                     "link": "http://www.naver.com",
//                     "geoLat": 37.27455854791513,
//                     "geoLon": 127.50946893739612,
//                     "address": "경기 고양시 일산동구 강송로 170 현대프라자",
//                     "number": "01073787605",
//                     "keywords": [
//                         {
//                             "content": "화장실이 청결해요",
//                             "count": 35
//                         },
//                         {
//                             "content": "단체모임 하기 좋아요",
//                             "count": 31
//                         },
//                         {
//                             "content": "여자/남자친구가 좋아해요",
//                             "count": 28
//                         }
//                     ]
//                 }
//
//            ]
//
//            """
//
//            do {
//                let model = try JSONDecoder().decode([PlaceModel].self, from: Data(str.utf8))
//                single(.success(model))
//            } catch {
//                single(.failure(NetworkError.parsing))
//            }

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
            print("getPlaceDetail")
            let str = """
            {
                "id": 1,
                "name": "옹심이네",
                "region": "서울",
                "bookmarkYn": true,
                "distance": 50.4,
                "price": 100000.0,
                "imageURLs": [
                "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2",
                "https://www.notion.so/image/https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F603cc735-a283-414d-82e4-677b48c2a9a4%2F16d95d59f310a0816dcf2b30f0d3e77f_3.png?table=block&id=607a22b3-b62f-4571-8426-42fae73e3409&spaceId=8f951a40-5f58-4e37-a434-f8779f97f587&width=2000&userId=711ecf32-2a4d-418b-9878-68474ca48176&cache=v2"
                ],
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
              "keywords": [
                  {
                      "content": "화장실이 청결해요",
                      "count": 35
                  },
                  {
                      "content": "단체 모임 하기 좋아요",
                      "count": 31
                  },
                  {
                      "content": "직원분들이 친절해요",
                      "count": 28
                  }
              ],
                "menus": [
                    {
                        "id": 1,
                        "name": "감자옹심이",
                        "price": 12000,
                        "imageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    },
                    {
                        "id": 1,
                        "name": "감자옹심이",
                        "price": 12000,
                        "imageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    },
                    {
                        "id": 1,
                        "name": "감자옹심이",
                        "price": 12000,
                        "imageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
                    },
                    {
                        "id": 1,
                        "name": "감자옹심이",
                        "price": 12000,
                        "imageURL": "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"
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

   

    

    // MARK: post review

    func postReview(images: [UIImage], content: String, keywords: [KeywordModel]) -> Single<Bool> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/Like") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("postReview")
            dump(images)
            dump(content)
            dump(keywords)
            Singleton.shared.myReviewRefresh.onNext(())
            single(.success(true))

            return Disposables.create()
        }
    }
    
    func deleteReview(_: Int) -> Single<Bool> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/Like") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("deleteReview")
            Singleton.shared.myReviewRefresh.onNext(())
            single(.success(true))

            return Disposables.create()
        }
    }

 
   

    // MARK: memo

    func postMemo(placeId: Int, content: String, color: String) -> Single<Bool> {
        return Single.create { single in
            guard let url = URL(string: "\(NetworkManager.uri)/api/Like") else {
                single(.failure(NetworkError.uri))
                return Disposables.create()
            }
            print("postMemo")
            
            UserDefaults.standard.set(content, forKey: "\(placeId)Content")
            UserDefaults.standard.set(color, forKey: "\(placeId)Color")
            
            single(.success(true))

            return Disposables.create()
        }
    }
}

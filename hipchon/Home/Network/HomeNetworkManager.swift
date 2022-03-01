//
//  HomeNetworkManager.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import Alamofire
import RxSwift
import RxCocoa

class HomeNetworkManager {
    
    private init() {}

    public static let shared = HomeNetworkManager()
    static let uri = "https://"
    static let headers: HTTPHeaders = [
        "Authorization": "some auth",
        "Accept": "application/json",
    ]
    
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
}

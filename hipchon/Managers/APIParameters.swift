//
//  APIParameters.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/29.
//

import Alamofire
import RxSwift
import SwiftKeychainWrapper

class APIParameters {
    
    private init() {}
    
    static let shared = APIParameters()
    private let bag = DisposeBag()
    var userId = "-1"
    var id = -1
    
    let hostUrl = "http://54.180.25.216"
    let headers: HTTPHeaders = [
        "Authorization": "some auth",
        "Accept": "application/json",
        // TODO: Token
    ]
    
    let session: Session = {
      let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5000
        configuration.timeoutIntervalForResource = 5000
      return Session(configuration: configuration)
    }()
    
    
    
    func refreshUserId() {
        userId = KeychainWrapper.standard.string(forKey: "userId") ?? "-1"
    }
}

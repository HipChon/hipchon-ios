//
//  LoginModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import Foundation

class LoginModel: Codable {
    let email: String?
    let password: String?

    enum CodingKeys: String, CodingKey {
        case email, password
    }

    init() {
        email = ""
        password = ""
    }

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }

    func emailValidCheck() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func passwordValidCheck() -> Bool {
        let passwordRegEx = "^(?=.*[!@#$%^&*()_+=-]).{8,20}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
}

//
//  TokenOfAuthAndUserProfile.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 20.12.2021.
//

import Foundation

struct GenderModel: Decodable {
    let code: Int
    let name: String
}

struct UserModel: Decodable {
    let id: Int
    let name: String
    let login: String
    let gender: GenderModel
}

struct TokenAndProfileModel: Decodable {
    let token: String
    let user: UserModel
}

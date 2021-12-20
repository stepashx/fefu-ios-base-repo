//
//  RegisterModel.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 20.12.2021.
//

import Foundation

struct RegisterModel: Encodable {
    let login: String
    let password: String
    let name: String
    let gender: Int
}

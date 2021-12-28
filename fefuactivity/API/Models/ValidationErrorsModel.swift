//
//  ValidationErrors.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 20.12.2021.
//

import Foundation

struct ValidationErrorsModel: Decodable {
    let errors: [String: [String]]
}

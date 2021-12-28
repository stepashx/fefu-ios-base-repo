//
//  Login.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 20.12.2021.
//

import Foundation

class Login {
    static private let url: String = "https://fefu.t.feip.co/api/auth/login"
    static let encoder = JSONEncoder()
    
    init() {
        Login.encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    static func login(body: Data, token: @escaping((TokenAndProfileModel) -> Void), errors: @escaping((ValidationErrorsModel) -> Void)) {
        guard let url = URL(string: Login.url) else {
            print("URL doesn't exist")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let data = data, let res = response as? HTTPURLResponse {
                switch res.statusCode {
                case 200:
                    do {
                        let tokenData = try Register.decoder.decode(TokenAndProfileModel.self, from: data)
                        token(tokenData)
                        return
                    } catch {
                        print(error)
                    }
                case 422:
                    do {
                        let errorsData = try Register.decoder.decode(ValidationErrorsModel.self, from: data)
                        errors(errorsData)
                        return
                    } catch {
                        print(error)
                    }
                default:
                    return
                }
            }
        }
        
        dataTask.resume()
    }
}

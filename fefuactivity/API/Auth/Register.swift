//
//  register.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 20.12.2021.
//

import Foundation

class Register {
    static private let url: String = "https://fefu.t.feip.co/api/auth/register"
    static let decoder = JSONDecoder()
    
    init() {
        Register.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    static func register(body: Data, token: @escaping((TokenAndProfileModel) -> Void), errors: @escaping((ValidationErrorsModel) -> Void)) {
        guard let url = URL(string: Register.url) else {
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
                case 201:
                    do {
                        let userData = try AuthService.decoder.decode(AuthUserModel.self, from: data)
                        completion(userData)
                        return
                    } catch {
                        print(error)
                    }
                case 422:
                    do {
                        let errData = try AuthService.decoder.decode(ApiError.self, from: data)
                        onError(errData)
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

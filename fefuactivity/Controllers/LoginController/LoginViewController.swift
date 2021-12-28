//
//  LoginViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 22.10.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: SignTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    
    @IBAction func didTapContinueButton(_ sender: Any) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        do {
            let loginModel = LoginModel(login: login, password: password)
            let body = try Auth.encoder.encode(loginModel)
            let queue = DispatchQueue.global(qos: .utility)
            
            Auth.auth(body: body, currentURL: Auth.loginURL) { user in
                queue.async {
                    UserDefaults.standard.set(user.token, forKey: "token")
                }
                DispatchQueue.main.async {
                    let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
                    mainViewController.modalPresentationStyle = .fullScreen
                    self.present(mainViewController, animated: true, completion: nil)
                }
            } errors: { error in
                DispatchQueue.main.async {
                    var message = ""
                    for (_, item) in error.errors.reversed() {
                        message += item.joined(separator: "\n") + "\n"
                    }
                    
                    let alert = UIAlertController(title: "Check fields", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } catch {
            print(error)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Вход"
    }
}

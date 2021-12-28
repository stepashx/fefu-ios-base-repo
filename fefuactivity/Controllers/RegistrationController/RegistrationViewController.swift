//
//  RegistrationViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 22.10.2021.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var loginTextField: SignTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var repeatPasswordTextField: PasswordTextField!
    @IBOutlet weak var nameOrNicknameTextField: SignTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var genderTextField: PopUpTextField!
    
    @IBAction func didTapContinueButton(_ sender: Any) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let repeatPassword = repeatPasswordTextField.text ?? ""
        let nameOrNickname = nameOrNicknameTextField.text ?? ""
        let gender = chooseGender(gender: genderTextField.text ?? "")
        
        if password != repeatPassword {
            showAlert(title: "Validation error", message: "Not the same passwords")
        }
        
        if gender == 2 {
            showAlert(title: "Validation error", message: "Choose gender")
        }
        
        do {
            let registerModel = RegisterModel(login: login, password: password, name: nameOrNickname, gender: gender)
            let body = try Auth.encoder.encode(registerModel)
            let queue = DispatchQueue.global(qos: .utility)
            
            Auth.auth(body: body, currentURL: Auth.registerURL) { user in
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
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func chooseGender(gender: String) -> Int {
        switch gender {
        case "Мужской":
            return 0
        case "Женский":
            return 1
        default:
            return 2
        }
    }
    
    let gender = ["", "Мужской", "Женский"]
    
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Регистрация"
        
        pickerView.delegate = self
        pickerView.dataSource = self
        self.genderTextField.inputView = pickerView
        
        registerForKeyboardNotifications()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_: )), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIWindow.keyboardDidHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardFrameSize.height)
        
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
}

extension RegistrationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = gender[row]
        genderTextField.resignFirstResponder()
    }
}

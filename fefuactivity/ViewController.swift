//
//  ViewController.swift
//  fefuactivity
//
//  Created by Andrew L on 04.10.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        
        let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        mainViewController.modalPresentationStyle = .fullScreen
        self.present(mainViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapRegistrationButton(_ sender: Any) {
        let controller = RegistrationViewController(nibName: "RegistrationViewController", bundle: nil)
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        let controller = LoginViewController(nibName: "LoginViewController", bundle: nil)
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

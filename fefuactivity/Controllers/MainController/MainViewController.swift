//
//  MainViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 02.12.2021.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityViewController = UINavigationController(rootViewController: ActivityViewController())
        activityViewController.title = "Активности"
        activityViewController.tabBarItem.image = UIImage(systemName: "circle")
        
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        profileViewController.title = "Профиль"
        profileViewController.tabBarItem.image = UIImage(systemName: "circle")
        
        self.setViewControllers([activityViewController, profileViewController], animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

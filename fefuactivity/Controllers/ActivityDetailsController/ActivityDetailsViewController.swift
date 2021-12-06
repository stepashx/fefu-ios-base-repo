//
//  ActivityDetailsViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 02.12.2021.
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Велосипед"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
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

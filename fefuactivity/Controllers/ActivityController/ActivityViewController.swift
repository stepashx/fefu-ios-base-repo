//
//  ActivityViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 02.12.2021.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var startButton: BaseButton!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var emptyStateStackView: UIStackView!
    
    let sections = ["Вчера", "Май 2022 года"]
    
    let activityCellId = "activityCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Активности"
        
        activityTableView.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: activityCellId)
        activityTableView.dataSource = self
        activityTableView.delegate = self
        activityTableView.backgroundColor = .clear
        activityTableView.isHidden = true
    }

    @IBAction func didTapStartButton(_ sender: Any) {
//        activityTableView.isHidden = false
//        emptyStateStackView.isHidden = true
        
        let controller = MKMapViewController(nibName: "MKMapViewController", bundle: nil)
        controller.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(controller, animated: true)
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

extension ActivityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityTableCell = activityTableView.dequeueReusableCell(withIdentifier: activityCellId, for: indexPath)
        
        guard let cell = activityTableCell as? ActivityTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 22.0)
        label.text = sections[section]
        
        return label
    }
}

extension ActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityDetailsController = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        
        navigationController?.pushViewController(activityDetailsController, animated: true)
    }
}

//
//  ActivityViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 02.12.2021.
//

import UIKit
import CoreData

struct dataModel {
    let date: Date
    var activities: [ActivityTableViewCellModel]
}

class ActivityViewController: UIViewController {

    @IBOutlet weak var startButton: BaseButton!
    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var emptyStateStackView: UIStackView!
    
    private var data = [dataModel]()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetch()
        self.activityTableView.reloadData()
    }
    
    private func fetch() {
        let context = FEFUCoreDataContainer.instance.context
        
        let activityRequest: NSFetchRequest<CoreDataActivity> = CoreDataActivity.fetchRequest()
        
        do {
            let rawActivities = try context.fetch(activityRequest)
            
            let activitiesViewModels: [ActivityTableViewCellModel] = rawActivities.map { rawActivity in
                
                let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()
            
                return ActivityTableViewCellModel(
                    date: rawActivity.date ?? Date(),
                    distance: rawActivity.distance,
                    duration: rawActivity.duration,
                    icon: image,
                    type: rawActivity.type ?? "",
                    startTime: rawActivity.startTime ?? "",
                    endTime: rawActivity.endTime ?? ""
                )
            }
            
            let groupedActivitiesByDate = Dictionary(grouping: activitiesViewModels) { activityViewModel in
                return createDate(activityViewModel.date)
            }
            
            self.data = groupedActivitiesByDate.map { (data, activities) in
                return dataModel(
                    date: data,
                    activities: activities
                )
            }
            
            emptyStateStackView.isHidden = !data.isEmpty
            activityTableView.isHidden = data.isEmpty
        } catch {
            print(error)
        }
    }
    
    private func createDate(_ activityDate: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: activityDate)
        return calendar.date(from: components) ?? Date()
    }

    @IBAction func didTapStartButton(_ sender: Any) {
//        activityTableView.isHidden = false
//        emptyStateStackView.isHidden = true
        
        let controller = MKMapViewController(nibName: "MKMapViewController", bundle: nil)
        controller.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    

}

extension ActivityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityTableCell = activityTableView.dequeueReusableCell(withIdentifier: activityCellId, for: indexPath)
        
        guard let cell = activityTableCell as? ActivityTableViewCell else {
            return UITableViewCell()
        }
        
        cell.addFields(model: data[indexPath.section].activities[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection
        section: Int) -> UIView? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 22.0)
        label.text = dateFormatter.string(from: data[section].date)
        
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
        activityDetailsController.model = data[indexPath.section].activities[indexPath.row]
        
        navigationController?.pushViewController(activityDetailsController, animated: true)
    }
}

//
//  ActivityDetailsViewController.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 02.12.2021.
//

import UIKit

class ActivityDetailsViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeAgoUpperLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startAndEndTimeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeAgoDownLabel: UILabel!
    
    var model: ActivityTableViewCellModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Велосипед"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
        
        self.addFields(model: self.model!)
    }


    func addFields (model: ActivityTableViewCellModel) {
        distanceLabel.text = String(format: "%.2f км", model.distance / 1000)
        
        let duration = DateComponentsFormatter()
        duration.allowedUnits = [.hour, .minute, .second]
        duration.zeroFormattingBehavior = .pad
        durationLabel.text = duration.string(from: model.duration)
    
        iconImage.image = model.icon
        typeLabel.text = model.type
        
        let dateFormatter = DateFormatter()
        timeAgoUpperLabel.text = dateFormatter.string(from: model.date)
        timeAgoDownLabel.text = dateFormatter.string(from: model.date)
        
        startAndEndTimeLabel.text = "Старт " + model.startTime + " · Финиш " + model.endTime
    }
}

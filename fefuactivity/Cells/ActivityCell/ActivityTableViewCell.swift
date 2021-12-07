//
//  ActivityTableViewCell.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 02.12.2021.
//

import UIKit

struct ActivityTableViewCellModel {
    let date: Date
    let distance: Double
    let duration: Double
    let icon: UIImage
    let type: String
    let startTime: String
    let endTime: String
}

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        activityView.backgroundColor = .white
        activityView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addFields (model: ActivityTableViewCellModel) {
        distanceLabel.text = String(format: "%.2f км", model.distance / 1000)
        
        let duration = DateComponentsFormatter()
        duration.allowedUnits = [.hour, .minute, .second]
        duration.zeroFormattingBehavior = .pad
        durationLabel.text = duration.string(from: model.duration)
    
        iconImage.image = model.icon
        typeLabel.text = model.type
        
        timeAgoLabel.text = DateFormatter().string(from: model.date)
    }
}

//
//  ActivityTypeCollectionViewCell.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 07.12.2021.
//

import UIKit

struct ActivityTypeCellModel {
    let type: String
    let title: String
}

class ActivityTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardTypeView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    var activityType: String?
    var activityTitle: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        cardTypeView.layer.cornerRadius = 14
        cardTypeView.layer.borderColor = UIColor.gray.cgColor
        cardTypeView.layer.borderWidth = 1
    }
    
    func addFields(model: ActivityTypeCellModel) {
        activityType = model.type
        activityTitle = model.title
        typeLabel.text = activityType
    }

}

//
//  ActivityTableViewCell.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 02.12.2021.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var activityView: UIView!
    
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
    
}

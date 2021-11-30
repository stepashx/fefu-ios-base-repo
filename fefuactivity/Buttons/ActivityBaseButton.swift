//
//  ActivityBaseButton.swift
//  fefuactivity
//
//  Created by Степан Хомулло on 01.11.2021.
//

import UIKit

class ActivityBaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ActivityBaseButtonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        ActivityBaseButtonInit()
    }
    
    func ActivityBaseButtonInit() {
        
    }
}

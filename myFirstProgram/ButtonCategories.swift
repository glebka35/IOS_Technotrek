//
//  ButtonWithImage.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 29/11/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

class ButtonCategories: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 8, left: (bounds.width - 45), bottom: 8, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }
    
}

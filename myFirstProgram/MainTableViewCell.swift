//
//  MainTableViewCell.swift
//  myFirstProgram
//
//  Created by Глеб Уваркин on 13/10/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    let gradient = CAGradientLayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setGradientToImage()
        setRadiusToImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setGradientToImage() {
        gradient.frame = myImage.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.6, 1]
        myImage.layer.insertSublayer(gradient, at: 0)
    }
    
    func setRadiusToImage() {
        myImage.layer.cornerRadius = 20
    }

}

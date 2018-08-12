//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

class ImageHeaderView : UIView {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!

    @IBOutlet weak var profileName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.backgroundColor = UIColor(hex: "E0E0E0")
        self.backgroundImage.layoutIfNeeded()
        self.backgroundImage.layer.cornerRadius = self.backgroundImage.bounds.size.height / 2
        self.backgroundImage.clipsToBounds = true
        self.backgroundImage.layer.borderWidth = 1
        self.backgroundImage.layer.borderColor = UIColor.white.cgColor
        self.backgroundImage.setRandomDownloadImage(80, height: 80)
        self.backgroundImage.setRandomDownloadImage(Int(self.bounds.size.width), height: 160)
    }
}

//
//  DataTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/8/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit

struct DataTableViewCellData {
    
    init(imageUrl: String, text: String) {
        self.imageUrl = imageUrl
        self.text = text
    }
    var imageUrl: String
    var text: String
}

class DataTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataText: UILabel!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cancelCampaignBtn: UIButton!
    
    @IBOutlet weak var selectCampaignBtn: UIButton!
    override func awakeFromNib() {
     //   self.dataText?.font = UIFont.italicSystemFont(ofSize: 16)
     //   self.dataText?.textColor = UIColor(hex: "9E9E9E")
      //  self.titleLable.text = "test"
      //  self.descriptionLabel.text = "test"
      //  self.priceLabel.text = "test"

    }
 
    override class func height() -> CGFloat {
        return 50
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellData {
            self.dataImage.setRandomDownloadImage(80, height: 80)
            self.dataText.text = data.text
        }
    }
}

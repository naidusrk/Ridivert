//
//  EarningsTableViewCell.swift
//  Ridevert
//
//  Created by RAMAKRISHNA NAIDU SAVARAM on 10/09/18.
//  Copyright © 2018 savaram, Ramakrishna. All rights reserved.
//

import UIKit

class EarningsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pauseCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

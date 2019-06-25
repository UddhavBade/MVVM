//
//  AMCTableViewCell.swift
//  MVVM
//
//  Created by Uddhav on 6/25/19.
//  Copyright © 2019 Uddhav. All rights reserved.
//

import UIKit

class AMCTableViewCell: UITableViewCell {

    @IBOutlet var amcNamelb: UILabel!
    @IBOutlet var amcCodelb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  searchUserTableViewCell.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/1.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class searchUserTableViewCell: UITableViewCell {

    @IBOutlet weak var avator: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var intro: UILabel!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var addImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addLabel.textColor = defaultColor
        addView.layer.borderWidth = 1.0
        addView.layer.cornerRadius = 6.0
        addView.layer.borderColor = defaultColor.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

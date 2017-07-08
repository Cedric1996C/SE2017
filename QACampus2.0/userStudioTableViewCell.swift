//
//  userStudioTableViewCell.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class userStudioTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var bgimage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var introduction: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        bgimage.layer.cornerRadius = 10.0
        bgimage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  HotTableViewCell.swift
//  QACampus2.0
//
//  Created by Demons on 2017/5/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class UserHotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

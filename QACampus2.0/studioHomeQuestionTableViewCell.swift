//
//  studioHomeQuestionTableViewCell.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class studioHomeQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var avator: UIImageView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var answer_num: UILabel!
    @IBOutlet weak var thumbTime: UILabel!
    
    @IBOutlet weak var seperateView: UIView!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperateView.backgroundColor = sectionHeaderColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

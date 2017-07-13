//
//  collectQuestionTableViewCell.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class collectQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var seperateView: UIView!
    @IBOutlet weak var avator: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var introduction: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperateView.backgroundColor = sectionHeaderColor
        seperateView.backgroundColor = sectionHeaderColor
        
        avator.contentMode = .scaleAspectFill
        //设置遮罩
        avator.layer.masksToBounds = true
        //设置圆角半径(宽度的一半)，显示成圆形。
        avator.layer.cornerRadius = avator.frame.width/2

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  studioAvatorTableViewCell.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/24.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class studioAvatorTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var avator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avator.contentMode = .scaleAspectFill
        //设置遮罩
        avator.layer.masksToBounds = true
        //设置圆角半径(宽度的一半)，显示成圆形。
        avator.layer.cornerRadius = avator.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

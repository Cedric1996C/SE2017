//
//  StudioInfoCollectionCell.swift
//  QACampus2.0
//
//  Created by 王乙飞 on 2017/7/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class StudioInfoCollectioCell:UICollectionViewCell{
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 6.0
        contentView.backgroundColor = iconColor
        contentView.backgroundColor = .white
        // Initialization code
        
    }
        
}

class StudioInfoListCell:UITableViewCell{
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.contentMode = .scaleAspectFill
        //设置遮罩
        icon.layer.masksToBounds = true
        //设置圆角半径(宽度的一半)，显示成圆形。
        icon.layer.cornerRadius = icon.frame.width/2
        // Initialization code
    }
    

}

class StudioInfoList2Cell:UITableViewCell{
    @IBOutlet weak var desc: UILabel!

}

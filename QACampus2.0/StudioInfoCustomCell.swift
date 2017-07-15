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
        // Initialization code
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        // Configure the view for the selected state
//    }

//    required init?(coder aDecoder: NSCoder) {
//    }
    
}

class StudioInfoListCell:UITableViewCell{
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
}

class StudioInfoList2Cell:UITableViewCell{
    @IBOutlet weak var desc: UILabel!

}

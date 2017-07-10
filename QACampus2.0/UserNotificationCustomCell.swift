//
//  UserNotificationCustomCell.swift
//  QACampus2.0
//
//  Created by 王乙飞 on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class UserNotificationCollection: UICollectionView{
    
}

class UserNotificationCollectionCell: UITableViewCell {
    @IBOutlet weak var clctView: UserNotificationCollection!
    
}

class UserNotificationListCell: UITableViewCell{
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var desc: UILabel!
}

class UserNotificationTitleCell: UITableViewCell{
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var titleR: UILabel!
    
}

class CollectionSubCell:UICollectionViewCell{
    @IBOutlet weak var label: UILabel!
    
}

class SubListCell: UITableViewCell{
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
}

//
//  collectStudioCell.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class collectStudioCell: UITableViewCell {

    @IBOutlet weak var seperateView: UIView!
    @IBOutlet weak var avator: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var introduction: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        seperateView.backgroundColor =  UIColor(red:255/255,green:235/255,blue:235/255,alpha:1)
        avator.contentMode = .scaleAspectFill
        avator.layer.masksToBounds = true
        avator.layer.cornerRadius = avator.frame.width/2
        
        picture.layer.cornerRadius = 10.0
        picture.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

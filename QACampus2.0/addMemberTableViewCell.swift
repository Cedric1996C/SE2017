//
//  addMemberTableViewCell.swift
//  
//
//  Created by NJUcong on 2017/6/30.
//
//

import UIKit

class addMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var avator: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
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

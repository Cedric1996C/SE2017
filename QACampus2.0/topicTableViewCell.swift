//
//  topicTableViewCell.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class topicTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = sectionHeaderColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class topicStudioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var authorAvator: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var studioName: UILabel!
    
    @IBOutlet weak var date: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = sectionHeaderColor

        authorAvator.contentMode = .scaleAspectFill
        //设置遮罩
        authorAvator.layer.masksToBounds = true
        //设置圆角半径(宽度的一半)，显示成圆形。
        authorAvator.layer.cornerRadius = authorAvator.frame.width/2
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class topicContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topicDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = sectionHeaderColor

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class topicSeperateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbView: UIImageView!
    
    @IBOutlet weak var commentNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = sectionHeaderColor
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class topicCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentAvator: UIImageView!
    @IBOutlet weak var commentor: UILabel!
    
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var seperate: UIView!
    @IBOutlet weak var date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        commentAvator.contentMode = .scaleAspectFill
        //设置遮罩
        commentAvator.layer.masksToBounds = true
        //设置圆角半径(宽度的一半)，显示成圆形。
        commentAvator.layer.cornerRadius = commentAvator.frame.width/2

        
        selectionStyle = .none
        contentView.backgroundColor = sectionHeaderColor
        seperate.backgroundColor = sectionHeaderColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

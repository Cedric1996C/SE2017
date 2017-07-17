//
//  pickAvatorTableViewCell.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/17.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class pickStudioTableViewCell: UITableViewCell {
   
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

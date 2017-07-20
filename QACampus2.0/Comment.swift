//
//  File.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class Comment {
    var id:Int?
    var name:String? = ""
    var content:String!
    var avator = UIImage(named:"no.1")
    var date:String = "1970-1-1"
    
    required init(id:Int, introduction: String?){        
        self.id = id
        self.content = introduction
        
    }
    
    
}

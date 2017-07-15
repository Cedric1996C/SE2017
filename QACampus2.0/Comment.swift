//
//  File.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class Comment {
    var id:Int?
    var user:String? = ""
    var content:String? = ""
    
    required init(id:Int, name: String?, introduction: String?){
        self.id = id
        self.user = name
        self.content = introduction
        
    }
    
    
}

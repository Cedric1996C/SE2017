//
//  Studio.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class Studio{
    
    var id: Int?
    var name: String?
    var introduction: String?
    
    required init(id:Int, name: String?, introduction: String?){
        self.id = id
        self.name = name
        self.introduction = introduction

    }
}

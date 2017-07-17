//
//  Question.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class Question {
    
    var id:Int?
    var name: String?
    var date:String?
    var title:String?
    var introduction: String?
    var thumbNum:Int?
    
    
    required init(name: String?,date:String?,title:String?, introduction: String?){
        self.name = name
        self.date = date
        self.title = title
        self.introduction = introduction
        
    }

}

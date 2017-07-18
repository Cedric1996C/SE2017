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
    var answer_num:Int?
    var thumb_num:Int?
    static var ask_id:Int = 1
    
    
    required init(id:Int, name: String?,date:String?,title:String?, introduction: String?,answer_num:Int){
        thumb_num = 0
        self.id = id
        self.name = name
        self.date = date
        self.title = title
        self.introduction = introduction
        self.answer_num = answer_num
        
    }

}

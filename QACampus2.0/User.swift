//
//  File.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class User:NSObject,NSCoding{
    
    var userId: String?
    var email: String?
    var password: String?
    var name: String?
    var introduction:String?
    var thumb_num:Int?
    var question_num:Int?
    var avator:NSObject!
    
    required init(email: String?, password: String?){
        self.userId = ""
        self.email = email
        self.password = password
    }
    
    required init(name: String?,introduction:String?,thumb_num: Int?,question_num: Int?){
        self.name = name
        self.introduction = introduction
        self.thumb_num = thumb_num
        self.question_num = question_num
    }
    
    //从object解析回来
    required init(coder decoder: NSCoder) {
        self.email = decoder.decodeObject(forKey: "email") as? String ?? ""
        self.password = decoder.decodeObject(forKey: "password") as? String ?? ""
    }
    
    //编码成object
    func encode(with coder: NSCoder) {
        coder.encode(email, forKey:"email")
        coder.encode(password, forKey:"password")
    }
}

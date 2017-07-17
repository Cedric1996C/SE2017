//
//  File.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

class User:NSObject,NSCoding{
    
    var userId: Int?
    var email: String?
    var password: String?
    var authorization: String?
    
    static var name:String! = "南大鸽子王"
    static var introduction:String! = "逢约必鸽，不见不散"
    
    static var answer_num:Int! = 0
    static var studio_num:Int! = 0
    static var question_num:Int! = 0
    static var myQuestion:Int! = 0
    static var collectQuestion:Int! = 0
    static var collectStudio:Int! = 0
    static var collectTopic:Int! = 0
    
    static var avator:UIImage! = UIImage(named: "no.1")
    
    static var localUserId:Int! = 0
    static var localEmail:String! = "973935302@qq.com"
    static var department:String! = "计算机科学与技术"
    
    required init(id:Int?,email: String?, password: String?, authorization:String?){
        self.userId = id
        self.email = email
        self.password = password
        self.authorization = authorization
    }
    
    //从object解析回来
    required init(coder decoder: NSCoder) {
        self.email = decoder.decodeObject(forKey: "email") as? String ?? ""
        self.password = decoder.decodeObject(forKey: "password") as? String ?? ""
        self.userId = decoder.decodeObject(forKey: "userId") as? Int
        self.authorization = decoder.decodeObject(forKey: "authorization") as? String ?? ""
    }
    
    //编码成object
    func encode(with coder: NSCoder) {
        coder.encode(email, forKey:"email")
        coder.encode(password, forKey:"password")
        coder.encode(userId, forKey:"userId")
        coder.encode(authorization, forKey: "authorization")
    }
}

//
//  File.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class User{
    var userId: String?
    var email: String?
    var password: String?
    
    required init(email: String?, password: String?){
        self.userId = ""
        self.email = email
        self.password = password
    }
}

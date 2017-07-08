//
//  userResponse.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/16.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import ObjectMapper

class userResponse: Mappable {
    var personalId: String?
    var introduce: String?
    var Qnum:Int?
    var Anum:Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        personalId <- map["personalId"]
        introduce <- map["introduce"]
        Qnum <- map["Qnum"]
        Anum <- map["Anum"]
    }
}

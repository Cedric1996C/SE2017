//
//  Answer.swift
//  QACampus2.0
//
//  Created by Eric Wen on 2017/7/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class Answer {
    
    let id: Int
    let str: String
    
    init(id: Int?, str: String?) {
        self.id = id ?? -1
        self.str = str ?? ""
    }
    
}

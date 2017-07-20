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
    let date: Date
    var answererId: Int = 0
    var answererAlias: String = ""
    
    
    
    init(id: Int?, str: String?, date: Date) {
        self.id = id ?? -1
        self.str = str ?? ""
        self.date = date
    }
    
}

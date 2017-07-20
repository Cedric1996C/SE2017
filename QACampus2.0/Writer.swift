//
//  Writer.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/20.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class Writer {
    
    let id: Int
    let str: String
    let date: Date
    var writerId: Int = 0
    var writerAlias: String = ""
    
    
    
    init(id: Int?, str: String?, date: Date) {
        self.id = id ?? -1
        self.str = str ?? ""
        self.date = date
    }
    
}

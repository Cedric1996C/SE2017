//
//  Abstract.swift
//  QACampus2.0
//
//  Created by Eric Wen on 2017/6/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

class Abstract {
    
    let id: Int
    let count: Int
    let title: String
    let detail: String
    
    init(id: Int?, count: Int?, title: String?, detail: String?) {
        self.id = id ?? -1
        self.count = count ?? 0
        self.title = title ?? ""
        self.detail = detail ?? ""
    }
    
}

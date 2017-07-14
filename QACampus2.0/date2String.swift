//
//  date2String.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/13.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation

//Date to String
func date2String(dateStamp: Int) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date:Date = NSDate(timeIntervalSince1970:TimeInterval(Int(dateStamp))) as Date
    let dateString = formatter.string(from: date)
    return dateString
}

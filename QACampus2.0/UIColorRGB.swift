//
//  UIColorRGB.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/24.
//  Copyright © 2017年 Demons. All rights reserved.
//


import UIKit

//ee6978
//bfbfbf
let originColor = UIColor(red: 0.96, green: 0.39, blue: 0.26, alpha: 1.0)
let blackColor = UIColor(red: 0.38, green: 0.39, blue: 0.40, alpha: 1.0)
let subTitleBorderColor = UIColor(red:0.8,green:0.8,blue:0.8,alpha:1.0)
let defaultColor = UIColor(valueRGB: 0xee6978, alpha: 1.0)
let sectionHeaderColor = UIColor(red:0.976,green:0.976,blue:0.976,alpha:1.0)
let sectionBackgroundColor = UIColor(red:0.960,green:0.960,blue:0.960,alpha:1.0)
let whiteColor = UIColor(red: 1.0, green: 1.0, blue:1.0, alpha: 1.0)
let iconColor = UIColor(red: 0.96, green: 0.39, blue: 0.35, alpha: 1.0)

let shadowColor = UIColor(red:220/255,green:220/255,blue:220/255,alpha:1)
let grey = UIColor(red:120/255,green:120/255,blue:120/255,alpha:1)

extension UIColor {
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(valueRGB: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((valueRGB & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueRGB & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueRGB & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

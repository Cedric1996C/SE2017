//
//  studioSubTitleFactory.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/24.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit


enum studioHomeSubType {
    case studioHomeSubQuestion    // 问题
    case studioHomeSubTopic       // 话题
}

class studioHomeSubFactory: NSObject {
    
    // MARK:- 生成子控制器
    class func studioHomeSubWith(identifier: String ) -> UIViewController {
        let studioHomeSubType: studioHomeSubType = typeFromTitle(identifier)
        var controller: UIViewController!
        switch studioHomeSubType {
        case .studioHomeSubQuestion:
            controller = UIStoryboard.init(name: "StudioHomeQuestion", bundle: nil).instantiateInitialViewController()
        case .studioHomeSubTopic:
            controller = UIStoryboard.init(name: "StudioHomeTopic", bundle: nil).instantiateInitialViewController()        default:
            controller =  UIStoryboard.init(name: "StudioHomeQuestion", bundle: nil).instantiateInitialViewController()        }
        return controller
    }
    
    // MARK:- 根据唯一标识符查找对应类型
    private class func typeFromTitle(_ title: String) -> studioHomeSubType {
        if title == "已解决" {
            return .studioHomeSubQuestion
        } else if title == "话题" {
            return .studioHomeSubTopic
        }
        return .studioHomeSubQuestion
        
    }
    
}

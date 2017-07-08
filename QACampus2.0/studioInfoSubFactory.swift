//
//  studioInfoSubFactory.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/23.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

enum studioInfoSubType {
    case studioInfoSubAnswer        // 最新回答
    case studioInfoSubTopic         // 最新话题
    case studioInfoSubHot           // 热门
    case studioInfoSubMember        //成员
}

class studioInfoSubFactory: NSObject {
    
    // MARK:- 生成子控制器
    class func studioInfoSubWith(identifier: String ) -> UIViewController {
        let studioInfoSubType: studioInfoSubType = typeFromTitle(identifier)
        var controller: UIViewController!
        switch studioInfoSubType {
        case .studioInfoSubAnswer:
            controller = studioAnswerViewController()
        case .studioInfoSubTopic:
            controller = studioTopicViewController()
        case .studioInfoSubHot:
            controller = studioHotViewController()
        case .studioInfoSubMember:
            controller = studioMemberViewController()
//        default:
//            controller = UIViewController()
        }
        return controller
    }
    
    // MARK:- 根据唯一标识符查找对应类型
    private class func typeFromTitle(_ title: String) -> studioInfoSubType {
        if title == "最新回答" {
            return .studioInfoSubAnswer
        } else if title == "最新话题" {
            return .studioInfoSubTopic
        } else if title == "热门" {
            return .studioInfoSubHot
        } else if title == "成员" {
            return .studioInfoSubMember
        }
        return .studioInfoSubAnswer
    }
    
}


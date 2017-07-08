//
//  personalSubFactory.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

enum personalSubType {
    case personalSubQuestion    // 问题
    case personalSubTopic       // 话题
    case personalSubStudio      // 工作室
}

class personalSubFactory: NSObject {
    
    // MARK:- 生成子控制器
    class func personalSubWith(identifier: String ) -> UIViewController {
        let personalSubType: personalSubType = typeFromTitle(identifier)
        var controller: UIViewController!
        switch personalSubType {
        case .personalSubQuestion:
                controller = personalQuestionViewController()
        case .personalSubTopic:
                controller = personalTopicViewController()
        case .personalSubStudio:
                controller = personalStudioViewController()
            default:
                controller = UIViewController()
        }
        return controller
    }
    
    // MARK:- 根据唯一标识符查找对应类型
    private class func typeFromTitle(_ title: String) -> personalSubType {
        if title == "问题" {
            return .personalSubQuestion
        } else if title == "话题" {
            return .personalSubTopic
        } else if title == "工作室" {
            return .personalSubStudio
        }
        return .personalSubStudio

    }

}

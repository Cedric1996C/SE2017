//
//  addAdminButtons.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/30.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

enum addAdminSubType {
    case addAdminAll            // 搜索全部
    case addAdminCollect        // 搜索关注
}

class addAdminButtons: NSObject {
    
    // MARK:- 生成子控制器
    class func addAdminSubWith(identifier: String ) -> UIViewController {
        let addAdminSubType: addAdminSubType = typeFromTitle(identifier)
        var controller: UIViewController!
        switch addAdminSubType {
        case .addAdminAll:
            controller = UIStoryboard.init(name: "AddAdmin", bundle: nil).instantiateViewController(withIdentifier: "SearchUser")
        case .addAdminCollect:
            controller = UIStoryboard.init(name: "AddAdmin", bundle: nil).instantiateViewController(withIdentifier: "SearchCollect")
        }
        return controller
    }
    
    // MARK:- 根据唯一标识符查找对应类型
    private class func typeFromTitle(_ title: String) -> addAdminSubType {
        if title == "全部" {
            return .addAdminAll
        } else if title == "关注" {
            return .addAdminCollect
        }
        return .addAdminAll
    }
    
}


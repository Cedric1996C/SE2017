//
//  HttpAuthen.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import Alamofire

// MARK: 使用https通信的ViewController，在ViewDidLoad方法中，调用该方法
func authentication() {
    //自签名网站地址

    let selfSignedHosts = ["192.168.0.1", "118.89.166.180","192.168.1.108", "115.159.199.121"]
    
    let manager = SessionManager.default
    manager.delegate.sessionDidReceiveChallenge = { session, challenge in
        //认证服务器（这里不使用服务器证书认证，只需地址是我们定义的几个地址即可信任）
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
            && selfSignedHosts.contains(challenge.protectionSpace.host) {
            print("服务器认证！")
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            return (.useCredential, credential)
        }
        else {
            print("其它情况（不接受认证）")
            return (.cancelAuthenticationChallenge, nil)
        }
    }

}

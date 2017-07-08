//
//  registerViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class registerViewController: UIViewController {

    let logoBox = logoView()//放置logo的盒子
    let log = logView()//登录主体部分
    let bottomBox = UIView()//其他部分

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        registerInit()
        // Do any additional setup after loading the view.
        authentication()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func registerInit(){
        log.setFieldNum(num: 2)
        view.addSubview(logoBox)
        view.addSubview(log)
        view.addSubview(UIView())
        view.addSubview(bottomBox)
        for i in 0...3 {
            view.subviews[i].snp.makeConstraints{ make in
                make.left.right.equalToSuperview()
                if i==0 {
                    make.top.equalToSuperview()
                    make.height.equalToSuperview().dividedBy(4)
                }
                else{
                    make.top.equalTo(view.subviews[i-1].snp.bottom)
                }
                if i==1{
                    make.height.equalToSuperview().dividedBy(2.5)
                }
                if i==2 {
                    make.height.equalToSuperview().dividedBy(4)
                }
                if i==3 {
                    make.bottom.equalToSuperview()
                }
            }
        }
        logoViewInit()
        bottomViewInit()
    }
    
    func logoViewInit() {
        logoBox.returnBtn.addTarget(self, action: #selector(registerDismiss), for: UIControlEvents.touchUpInside)
        log.logBtn.setTitle("注册", for: .normal)
        log.logBtn.addTarget(self, action: #selector(userRegister), for: UIControlEvents.touchUpInside)
    }

    func bottomViewInit () {
        let bottomView = bottomChoicesView()
        bottomBox.addSubview(bottomView)
        bottomView.snp.makeConstraints{ make in
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.left.right.equalToSuperview()
        }
        bottomView.choices[0].setTitle("已有账号登录", for: .normal)
        bottomView.choices[0].addTarget(self, action: #selector(registerDismiss), for: UIControlEvents.touchUpInside)
    }
    
    func registerDismiss(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func userRegister(sender:UIButton){
        let user = User(email: log.getEmail(),password: log.getPassword())
        let parameters: Parameters = [
            "email": user.email!,
            "password": user.password!
        ]
        Alamofire.request("https://localhost:8443/auth/register",method: .post, parameters: parameters).responseString { response in
            debugPrint(response)
          //.responseObject {(response: DataResponse<userResponse>) in
          //   let userJson = response.result.value
        }
    }
}

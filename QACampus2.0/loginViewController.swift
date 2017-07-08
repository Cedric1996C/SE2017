//
//  loginViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire

let shadowColor = UIColor(red:220/255,green:220/255,blue:220/255,alpha:1)
let grey = UIColor(red:120/255,green:120/255,blue:120/255,alpha:1)

class loginViewController: UIViewController {

    let logoBox = logoView()//放置logo的盒子
    let log = logView()//登录主体部分
    let mediaView = UIView()//其他登录方式
    let solveView = UIView()//其他部分
    
    let infoView = UIView()//信息框
    let devideLine = UIView()//分割线
   
    let logQuestion = UIButton()//登录遇到问题
    let mediaTag = UIView()//社交账号直接登录
    let accountView = UIView()//社交账号的容器
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginInit()
        authentication()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginInit(){
        log.setFieldNum(num: 2)
        view.addSubview(logoBox)
        view.addSubview(log)
        view.addSubview(mediaView)
        view.addSubview(solveView)
        logoBox.backgroundColor = .white
        log.backgroundColor = .white
        mediaView.backgroundColor =  .white
        solveView.backgroundColor = .white
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
        logViewInit()
        mediaViewInit()
        solveViewInit()
    }
    
    // MARK: logoView初始化
    func logoViewInit() {
        logoBox.returnBtn.addTarget(self, action: #selector(returnInfo), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: logView初始化
    func logViewInit(){
        let logBtn = log.logBtn
        logBtn.setTitle("登录", for: .normal)
        logBtn.addTarget(self, action: #selector(login), for: UIControlEvents.touchUpInside)
    }
    
    // MARK: mediaView初始化
    func  mediaViewInit(){
        mediaView.addSubview(logQuestion)
        mediaView.addSubview(mediaTag)
       
        logQuestion.setTitle("登录遇到问题", for: .normal)
        logQuestion.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        logQuestion.setTitleColor(shadowColor,for: .normal)
        logQuestion.snp.makeConstraints{ make in
            make.height.equalToSuperview().dividedBy(6)
            make.width.equalToSuperview().dividedBy(2)
            make.top.centerX.equalToSuperview()
        }
        
        mediaTag.backgroundColor = .white
        mediaTag.snp.makeConstraints{ make in
            make.width.equalToSuperview().dividedBy(1.5)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(6)
            make.centerY.equalToSuperview().offset(-20)
        }
        
        let divideLine1 = UIView()
        let divideLine2 = UIView()
        let divideLabel = UILabel()
        divideLine1.backgroundColor = shadowColor
        divideLine2.backgroundColor = shadowColor
        divideLabel.text = "上次登录账号"
        divideLabel.textColor = shadowColor
        divideLabel.font = UIFont.systemFont(ofSize: 14)
        divideLabel.textAlignment = NSTextAlignment.center
        
        mediaTag.addSubview(divideLine1)
        mediaTag.addSubview(divideLine2)
        mediaTag.addSubview(divideLabel)
        
        divideLine1.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(4.1)
            make.height.equalTo(2)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        divideLine2.snp.makeConstraints{ make in
            make.width.equalToSuperview().dividedBy(4.1)
            make.height.equalTo(2)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        divideLabel.snp.makeConstraints{ make in
            make.width.equalToSuperview().dividedBy(2)
            make.height.centerX.centerY.equalToSuperview()
        }
        
        mediaView.addSubview(accountView)
        accountView.backgroundColor = .white
        accountView.snp.makeConstraints{ make in
            make.height.equalToSuperview().dividedBy(4)
            make.width.equalToSuperview().dividedBy(1.5)
            make.centerX.equalToSuperview()
            make.top.equalTo(mediaTag.snp.bottom).offset(10)
        }
        let account = UILabel()
        accountView.addSubview(account)
        account.text = "141220045@nju.edu.cn"
        account.textColor = .black
        account.font = UIFont.systemFont(ofSize: 14)
        account.textAlignment = NSTextAlignment.center
        account.snp.makeConstraints { make in
            make.height.centerY.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.2)
        }
        
    }
    
    //MARK: solveView初始化
    func solveViewInit () {
        let bottomView = bottomChoicesView()
        solveView.addSubview(bottomView)
        bottomView.snp.makeConstraints{ make in
            make.height.equalToSuperview().dividedBy(2)
            make.bottom.left.right.equalToSuperview()
        }
        bottomView.choices[0].addTarget(self, action: #selector(register), for: UIControlEvents.touchUpInside)
    }
    
    //用户登录函数
    func login(sender:UIButton){
         let user = User(email: log.getEmail(),password: log.getPassword())
         let parameters: Parameters = [
            "email": user.email!,
            "password": user.password!
         ]
         Alamofire.request("https://localhost:8443/auth/login",method: .post, parameters: parameters).responseString { response in
            if let headers = response.response?.allHeaderFields as? [String: String]{
                let header = headers["Authorization"]
                debugPrint(header!)
            }
        }
         
    }
    
    func returnInfo(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func register(sender:UIButton){
        let registerView = registerViewController()
        self.present(registerView, animated: true, completion: nil)
    }

}

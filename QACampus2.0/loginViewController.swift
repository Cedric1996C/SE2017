//
//  loginViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire

class loginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var regulations: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var statusCode:Int = 0
    
    lazy var alert:alertView = {
        return alertView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        authentication()
        // Do any additional setup after loading the view.
    }

    func  UIInit(){
        email.attributedPlaceholder = NSAttributedString(string: "登录邮箱",attributes: [NSForegroundColorAttributeName: UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: "密码",attributes: [NSForegroundColorAttributeName: UIColor.white])
        loginBtn.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func loginBtnClick(_ sender: Any) {
        let headers:HTTPHeaders = [
            "email": email.text!,
            "password": password.text!
        ]
        //        var statusCode:Int?
        //        print(parameters)
        Alamofire.request("https://\(root):8443/login",method: .get, headers:headers).responseString { response in
            self.statusCode = (response.response?.statusCode)!
            print(self.statusCode)
            self.loginResult(result: self.statusCode)
            
        }
    }
    
    func loginResult(result:Int){
        
        //        let alert = alertView()
        self.view.addSubview(alert)
        alert.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.height.equalTo(175.0)
            make.width.equalTo(275.0)
        })
        
        alert.layer.zPosition = 100
        
        switch result {
        case 422:
            alert.addContent(content: "错误的邮箱格式，请重新输入！")
            alert.addImage(image: UIImage(named:"alert_wrong")!)
        case 500:
            alert.addContent(content: "用户不存在，请重试！")
            alert.addImage(image: UIImage(named:"alert_wrong")!)
        default:
            alert.addContent(content: "验证成功，正在登陆！")
            alert.addImage(image: UIImage(named:"alert_right")!)
        }
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(alertEnd), userInfo: nil, repeats: false);
    }
    
    func alertEnd() {
        if statusCode == 200 {
            saveLocalUser()
            let mainVC = UIStoryboard(name: "MainInterface", bundle: nil).instantiateInitialViewController()
            self.present(mainVC!, animated: true, completion: nil)
        } else {
            alert.removeFromSuperview()
        }
    }
    
    //存储登录的账户
    func saveLocalUser() {
        let userDefault = UserDefaults.standard
        //自定义对象存储
        let user = User(email: email.text, password: password.text)
        //实例对象转换成Data
        let modelData = NSKeyedArchiver.archivedData(withRootObject: user)
        //存储Data对象
        userDefault.set(modelData, forKey: "local_user")
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
//        localUserCheck()
    }

    @IBAction func register(_ sender: Any) {
        let registerVC = UIStoryboard(name: "Register", bundle: nil).instantiateInitialViewController()
        self.present(registerVC!, animated: true, completion: nil)
    }
    
    @IBAction func email_cancel(_ sender: Any) {
        email.text = ""
    }
    
    @IBAction func password_cancel(_ sender: Any) {
        password.text = ""
    }
}

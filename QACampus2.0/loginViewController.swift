//
//  loginViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class loginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var regulations: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var statusCode:Int = 0
    
    lazy var alert:alertView = {
        return alertView()
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        resetLocalUser()
    }
    
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
        Alamofire.request("https://\(root):8443/login",method: .get, headers:headers).responseJSON { response in
            
            self.statusCode = (response.response?.statusCode)!
            if let headers = response.response?.allHeaderFields as? [String: String]{
                if self.statusCode == 200 {
                    userAuthorization = headers["Authorization"]!
                }
            }
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
        let timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(alertEnd), userInfo: nil, repeats: false);
    }
    
    func alertEnd() {
     
        if statusCode == 200 {
            saveLocalUser()
        } else {
            alert.removeFromSuperview()
        }
    }
    
    //存储登录的账户
    func saveLocalUser() {
        
        let userDefault = UserDefaults.standard
        
        let headers:HTTPHeaders = [
            "Authorization":userAuthorization,
            "email": email.text!
        ]
        
        Alamofire.request("https://\(root):8443/owner-service/owners/email", method: .get,headers: headers).responseJSON { response in
            
            if  response.result.value != nil {
                var userJSON = JSON(response.result.value!)
                let id:Int = userJSON["id"].int!
                
                //自定义对象存储
                let user = User(id:id,email: self.email.text, password: self.password.text)
                let modelData = NSKeyedArchiver.archivedData(withRootObject: user)
                userDefault.set(modelData, forKey: "local_user")
                
            }
            let mainVC = UIStoryboard(name: "MainInterface", bundle: nil).instantiateInitialViewController()
            self.present(mainVC!, animated: true, completion: nil)
        }
    }


    //重置登录的用户
    func resetLocalUser() {
        let userDefault = UserDefaults.standard
        userDefault.set("nobody", forKey: "local_user")
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

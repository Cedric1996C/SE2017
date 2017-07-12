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

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    lazy var alert:alertView = {
        return alertView()
    }()
    
    var statusCode:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIInit()
        authentication()
        // Do any additional setup after loading the view.
    }
    
    func  UIInit(){
        email.attributedPlaceholder = NSAttributedString(string: "NJU邮箱",attributes: [NSForegroundColorAttributeName: UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: "账户密码",attributes: [NSForegroundColorAttributeName: UIColor.white])
        registerBtn.layer.cornerRadius = 5.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerBtnClick(_ sender: Any) {
        
        let headers:HTTPHeaders = [
            "email": email.text!,
            "password": password.text!
        ]
//        var statusCode:Int?
//        print(parameters)
        Alamofire.request("https://\(root):8443/register",method: .post, headers:headers).responseString { response in
            self.statusCode = (response.response?.statusCode)!
            print(self.statusCode)
            self.registerResult(result: self.statusCode)

        }
        
    }

    func registerResult(result:Int){

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
            alert.addContent(content: "错误的邮箱格式，请重新输入")
            alert.addImage(image: UIImage(named:"alert_wrong")!)
        case 226:
            alert.addContent(content: "该邮箱已被注册，请重试")
            alert.addImage(image: UIImage(named:"alert_wrong")!)
        default:
            alert.addContent(content: "注册成功，正在登陆！")
            alert.addImage(image: UIImage(named:"alert_right")!)
        }
        let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(alertEnd), userInfo: nil, repeats: false);
        
    }

    func alertEnd() {
        if statusCode == 200 {
            let mainVC = UIStoryboard(name: "MainInterface", bundle: nil).instantiateInitialViewController()
            self.present(mainVC!, animated: true, completion: nil)
        } else {
             alert.removeFromSuperview()
        }
    }
    
    @IBAction func accountLogin(_ sender: Any) {
        let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        self.present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func email_cancel(_ sender: Any) {
        email.text = ""
    }
    
    @IBAction func password_cancel(_ sender: Any) {
        password.text = ""
    }
    
    
}

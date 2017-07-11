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
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
    }

    @IBAction func register(_ sender: Any) {
    }
    
}

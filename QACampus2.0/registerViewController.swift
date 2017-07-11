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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        authentication()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func userRegister(sender:UIButton){
//        let user = User(email: log.getEmail(),password: log.getPassword())
//        let parameters: Parameters = [
//            "email": user.email!,
//            "password": user.password!
//        ]
//        Alamofire.request("https://localhost:8443/auth/register",method: .post, parameters: parameters).responseString { response in
//            debugPrint(response)
//          //.responseObject {(response: DataResponse<userResponse>) in
//          //   let userJson = response.result.value
//        }
    }
}

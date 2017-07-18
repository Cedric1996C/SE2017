//
//  PersonalEditTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PersonalEditTableViewController: editTableViewController {
    
    lazy var tagTitle:[String] = {
        return ["昵称","简介"]
    }()
    
    var delegate:editDelegate?
    var tabDelegate:tabDelegate?
    var avator:UIImage = User.avator
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        animationForDismiss()
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        authentication()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = sectionHeaderColor
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        view.tintColor = sectionHeaderColor
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch  indexPath.section {
        case 0:
            return 80.0
        case 1:
            switch indexPath.row {
            case 0:
                return 60.0
            case 1:
                return 120.0
            case 2:
                return 60.0
            default:
                return 60.0
            }
        default:
            return 40.0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAvator", for: indexPath) as! editAvatorTableViewCell
            cell.avator.image = avator
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editInfo", for: indexPath) as! editInfoTableViewCell
            switch indexPath.row {
            case 0:
                cell.content.placeholder = User.name
            case 1:
                cell.content.placeholder = User.introduction
            default:
                cell.content.placeholder = User.department
            }
            cell.tagTitle.text = tagTitle[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagNavigation", for: indexPath) as! tagNavigationTableViewCell
            cell.tagName.text = indexPath.row==0 ? "重置密码":"退出账户"
            return cell
        }
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            selectIcon()
        case 2:
            if(indexPath.row == 0) {
                performSegue(withIdentifier: "reset", sender: self)
            } else {
                tabDelegate?.tab()
//                view.bringSubview(toFront: newController.view);
                let loginVc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController()
                self.present(loginVc!, animated: true, completion: nil)
            }
        default:
            break
        }
    }

    func cancel(sender:Any){
        self.dismiss(animated: false, completion: nil)
    }
    
    override func save(sender:Any) {
        let path = "owner-service/owners/\(User.localUserId!)"
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        
        var index = IndexPath(row:0, section: 1)
        var cell = tableView.cellForRow(at:index) as! editInfoTableViewCell
        if cell.content.text != User.name && cell.content.text != "" {
            changeDisplayName(name: cell.content.text,path: path)
        }
        index = IndexPath(row:1,section: 1)
        cell = tableView.cellForRow(at:index) as! editInfoTableViewCell
        if cell.content.text != User.introduction  && cell.content.text != ""{
            changeIntroduction(introduction: cell.content.text, path: path)
        }
        
        if avator != User.avator {
            let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("personalAvator")
            //准备上传头像
            prepareForStorage(fullPath, destination: uploadRoot+"user/\(User.localUserId!)")
            print(uploadRoot+"user/\(User.localUserId!)")
//            prepareForStorage(fullPath, destination: "https://192.168.1.108:6666/user/1")

        }
        
        delegate?.saveClicked(controller: self)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension PersonalEditTableViewController {
    
    func changeDisplayName(name:String,path:String) {
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        let parameters:Parameters = ["displayname": name]
        Alamofire.request("https://\(root):8443/\(path)/displayname" , method: .post, parameters:parameters,headers: headers).responseJSON { response in
            print(response.response?.statusCode)
        }
    }
    
    func changeIntroduction(introduction:String,path:String) {
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        let parameters:Parameters = ["introduction": introduction]
        Alamofire.request("https://\(root):8443/\(path)/introduction" , method: .post, parameters:parameters,headers: headers).responseJSON { response in
            
        }
    }
}

protocol editDelegate{
    
    func saveClicked(controller:PersonalEditTableViewController)

}


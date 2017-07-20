//
//  personalInfoTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class personalInfoTableViewController: UITableViewController ,editDelegate{

    lazy var tagNames:[String] = {
        return ["我的问题","收藏问题","收藏话题","收藏工作室"]
    }()
    
    lazy var tagNums:[Int] = {
        return [
            User.myQuestion,
            User.collectQuestion,
            User.collectTopic,
            User.collectStudio
        ]
    }()

    override func viewDidLoad() {
        authentication()
        super.viewDidLoad()
        initData()
        view.backgroundColor = sectionHeaderColor
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 0
        case 2:
            return 4
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "personalInfo", for: indexPath) as! personalInfoTableViewCell
            cell.name.text = User.name
            cell.introduction.text = User.introduction
            cell.questionNum.text = String(User.question_num)
            cell.thumbNum.text = String(User.studio_num)
            cell.avator.image = User.avator
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagNavigation", for: indexPath) as! tagNavigationTableViewCell
            cell.tagName.text = "全部动态"
            cell.num.text = ""
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagNavigation", for: indexPath) as! tagNavigationTableViewCell
            cell.tagName.text = tagNames[indexPath.row]
//            cell.num.text = String(tagNums[indexPath.row])
            cell.num.text = ""
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "space", for: indexPath) as! spaceTableViewCell
            cell.backgroundColor = sectionHeaderColor
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "myEdit", sender: self)
        case 2:
            if(indexPath.section == 2 ){
                if (indexPath.row == 0){
                    performSegue(withIdentifier: "myQuestion", sender: self)
                } else if (indexPath.row == 1){
                    performSegue(withIdentifier: "collectQuestion", sender: self)
                } else if (indexPath.row == 2){
                    performSegue(withIdentifier: "collectTopic", sender: self)
                } else {
                    performSegue(withIdentifier: "collectStudio", sender: self)
                }
            }
        default:
            break
        }
    }


    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        } else {
            return 20.0
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = sectionHeaderColor
    }


    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
       view.tintColor = sectionHeaderColor
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0  {
            return 240.0
        }
        else {
            return 50.0
        }
    }
    
}

extension personalInfoTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigation:UINavigationController
        if(segue.identifier == "myEdit"){
            navigation = segue.destination as! UINavigationController
            let editVc:PersonalEditTableViewController = navigation.topViewController as! PersonalEditTableViewController
            editVc.delegate = self
        }
    }
    
}



extension personalInfoTableViewController {
  
    //初始化personalInfo,头像、昵称、简介、各数字
    func initData () {
        
        let path = "user/\(User.localUserId!)"
        print(path)
        //请求用户的头像
        Alamofire.request(storageRoot+path, method: .get).responseJSON { response in
           
            if response.response?.statusCode == 200 {
                let json = response.result.value
//                print(json)
                if let pictures:[String] = json as! [String] {
                    let pic_path = path.appending("/" + pictures[0])
                    print(pic_path)
                    //获取文件
                    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let fileURL = documentsURL.appendingPathComponent(pic_path)
                        
                        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                    }
                    
                    Alamofire.download(uploadRoot + pic_path, to: destination).response { response in
                        if response.error == nil, let imagePath = response.destinationURL?.path {
                            User.avator = getPicture(pic_path)
                            self.reload()
                        }
                    }
                }
            }
        }
        
        let headers:HTTPHeaders = [
            "Authorization":userAuthorization
        ]
        
        //请求用户的信息
        Alamofire.request("https://\(root):8443/owner-service/owners/\(User.localUserId!)", method: .get,headers: headers).responseJSON { response in
            
            if  response.result.value != nil {
                if (response.response?.statusCode)! == 200 {
                    let userJSON = JSON(response.result.value!)
                
                    User.question_num = userJSON["question_num"].int
                    User.answer_num = userJSON["answer_num"].int
                    User.studio_num = userJSON["studio_num"].int
                    var temp: JSON = userJSON["question"]
                    User.myQuestion = temp.array?.count
                    temp = userJSON["_question_collect"]
                    User.collectQuestion = temp.array?.count
                    temp = userJSON["_studio_collect"]
                    User.collectStudio = temp.array?.count
                    temp = userJSON["_topic_collect"]
                    User.collectTopic = temp.array?.count
                    User.name = userJSON["display_name"].string
                    User.introduction = userJSON["introduction"].string
                }
            }
            self.reload()
            
        }

    }
    
    func saveClicked(controller: PersonalEditTableViewController) {
        initData()
    }
    
    func reload () {
        self.tableView.reloadData()
    }
    
}

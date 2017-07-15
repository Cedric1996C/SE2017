//
//  personalInfoTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class personalInfoTableViewController: UITableViewController {

    lazy var tagNames:[String] = {
        return ["我的问题","收藏问题","收藏话题","收藏工作室"]
    }()
    
    lazy var tagNums:[String] = {
        return ["0","0","0","0"]
    }()
    
    lazy var user:User = {
        return User(name:"南大鸽子王",introduction:"逢约必鸽，不见不散",thumb_num:1,question_num:2)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = sectionHeaderColor
        user.avator = UIImage(named:"no.1")
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
            cell.name.text = user.name
            cell.introduction.text = user.introduction
            cell.questionNum.text = String(describing: user.question_num!)
            cell.thumbNum.text = String(describing: user.thumb_num!)
            cell.avator.image = user.avator as! UIImage
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagNavigation", for: indexPath) as! tagNavigationTableViewCell
            cell.tagName.text = "全部动态"
            cell.num.text = ""
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagNavigation", for: indexPath) as! tagNavigationTableViewCell
            cell.tagName.text = tagNames[indexPath.row]
            cell.num.text = tagNums[indexPath.row]
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
        case 1:
            performSegue(withIdentifier: "myNews", sender: self)
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

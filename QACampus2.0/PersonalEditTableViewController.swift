//
//  PersonalEditTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class PersonalEditTableViewController: editTableViewController {

    lazy var tagTitle:[String] = {
        return ["昵称","简介","所在院系"]
    }()
    
    var avator:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        animationForDismiss()
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        authentication()
        // 设置 tabelView 行高,自动计算行高
        tableView.rowHeight = UITableViewAutomaticDimension
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableView.estimatedRowHeight = 300

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
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
            return 3
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
            cell.tagTitle.text = tagTitle[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagNavigation", for: indexPath) as! tagNavigationTableViewCell
            cell.tagName.text = indexPath.row==0 ? "重置密码":"退出账户"
            return cell
        }
    }
 


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            selectIcon()
//            let path = "/Users/njucong/Downloads/like01.png"
//            prepareForStorage(path)
        case 2:
            if(indexPath.row == 0) {
                performSegue(withIdentifier: "reset", sender: self)
            } else {
                let loginVc = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController()
                self.present(loginVc!, animated: true, completion: nil)
            }
        default:
            break
        }
    }

    func cancel(sender:Any){
        self.dismiss(animated: false, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
}

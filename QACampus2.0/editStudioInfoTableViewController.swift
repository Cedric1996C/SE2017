//
//  editStudioInfoTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/24.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class editStudioInfoTableViewController: UITableViewController,editTableViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var itemDataSource: [[(String)]] = [
        [("")],
        [("头像")],
        [("名称"),("所属单位"),("主页"),("简介")],
        [("管理员")],
        [("南大鸽子王")],
        [("成员")],
        [("南大鸽子王")],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
        view.backgroundColor = sectionHeaderColor
    }
    
    func initButton(){
        let item=UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(returnHome))
        item.tintColor = defaultColor
        self.navigationItem.leftBarButtonItem = item
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 2 || section == 4 || section == 6{
            return 0
        } else if section == 1 {
            return 0.5
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0 {
            return 0.5
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        if section != 4 && section != 6 {
            view.tintColor = sectionHeaderColor
            let divideLine = UIView()
            divideLine.backgroundColor = subTitleBorderColor
            view.addSubview(divideLine)
        divideLine.snp.makeConstraints({ make in
                make.height.equalTo(0.5)
                make.left.right.bottom.equalToSuperview()
            })
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        view.tintColor = subTitleBorderColor
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.section == 1){
            selectIcon()
        }
        else if(indexPath.section == 2 ){
            if (indexPath.row == 0){
                performSegue(withIdentifier: "editName", sender: self)
            } else if (indexPath.row == 1){
                performSegue(withIdentifier: "editUnit", sender: self)
            } else if (indexPath.row == 2){
                performSegue(withIdentifier: "editBlog", sender: self)
            } else if (indexPath.row == 3){
                performSegue(withIdentifier: "editIntro", sender: self)
            }
        }
        else if(indexPath.section == 3 || indexPath.section == 5){
            performSegue(withIdentifier: "addAdmin", sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 30.0
        } else {
            return 55.0
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return itemDataSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let rows = itemDataSource[section]
        return rows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"space",for: indexPath )
            cell.contentView.backgroundColor = sectionHeaderColor
            return cell
        } else if indexPath.section == 1 {
            let cell:studioAvatorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "studioAvatorCell") as! studioAvatorTableViewCell
            let item = itemDataSource[indexPath.section][indexPath.row]
            cell.title.text = item
            cell.avator.image = UIImage(named: "no.1")
            
            return cell
        } else if indexPath.section == 2 {
            let cell:studioInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "studioInfoCell") as! studioInfoTableViewCell
            let item = itemDataSource[indexPath.section][indexPath.row]
            cell.title.text = item
            cell.content.text = "未设置"
            cell.content.textColor = subTitleBorderColor
            return cell
        } else if indexPath.section == 3 || indexPath.section == 5{
            let cell:studioAdminTableViewCell = tableView.dequeueReusableCell(withIdentifier: "studioAdminCell") as! studioAdminTableViewCell
            let item = itemDataSource[indexPath.section][indexPath.row]
            cell.title.text = item
            cell.content.text = "点击添加"
            cell.content.textColor = subTitleBorderColor

            return cell
        } else {
            let cell:addMemberTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addMember") as! addMemberTableViewCell
            let item = itemDataSource[indexPath.section][indexPath.row]
            cell.avator.image =  UIImage(named: "no.1")
            cell.name.text = item
            return cell
        }

    }
    
}

// 跳转关系及相关编辑
extension editStudioInfoTableViewController {
   
    //Return to superVc
    func returnHome(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigation:UINavigationController
        if(segue.identifier == "editName"){
            navigation = segue.destination as! UINavigationController
            let editNameVc:editNameTableViewController = navigation.topViewController as! editNameTableViewController
            editNameVc.delegate = self
            editNameVc.nameString = "123"
        } else if (segue.identifier == "editUnit"){
            navigation = segue.destination as! UINavigationController
            let editUnitVc:editUnitTableViewController = navigation.topViewController as! editUnitTableViewController
            editUnitVc.delegate = self
            editUnitVc.unitString = "456"
        } else if (segue.identifier == "editIntro") {
            navigation = segue.destination as! UINavigationController
            let editIntroVc:editIntroTableViewController = navigation.topViewController as! editIntroTableViewController
            editIntroVc.delegate = self
            editIntroVc.introString = "456456645664566456645664566456645664566456645664566456645664566456645664566456645664566456"
        } else if (segue.identifier == "editBlog") {
            navigation = segue.destination as! UINavigationController
            let editBlogVc:editBlogTableViewController = navigation.topViewController as! editBlogTableViewController
            editBlogVc.delegate = self
            editBlogVc.blogString = "www.baidu.com"
        } else if (segue.identifier == "addAdmin") {
            let addAdminVc = segue.destination as! addAdminViewController
            let searchAdminVc = addAdminVc.controllers[0] as! searchAdminTableViewController
            let searchMemberVc = addAdminVc.controllers[1] as! searchCollectTableViewController
            searchAdminVc.delegate = self
            searchMemberVc.delegate = self
        }
        
    }
    
    //delegate
    func saveName(controller:editNameTableViewController, newInfo:String){
        let index = IndexPath(row:0, section: 2)
        let cell = tableView.cellForRow(at:index) as! studioInfoTableViewCell
        cell.content.text = newInfo
        //关闭编辑页面
        controller.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func editNameDidCancer(controller:editNameTableViewController){
        //关闭编辑页面
        controller.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func editUnitDidCancer(controller: editUnitTableViewController) {
        controller.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func saveUnit(controller: editUnitTableViewController, newInfo: String) {
        let index = IndexPath(row:1, section: 2)
        let cell = tableView.cellForRow(at:index) as! studioInfoTableViewCell
        cell.content.text = newInfo
        controller.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func editIntroDidCancer(controller: editIntroTableViewController) {
        controller.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func saveIntro(controller: editIntroTableViewController, newInfo: String) {
        let index = IndexPath(row:2, section: 2)
        let cell = tableView.cellForRow(at:index) as! studioInfoTableViewCell
        cell.content.text = newInfo
        controller.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func editBlogDidCancer(controller: editBlogTableViewController) {
        controller.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func saveBlog(controller: editBlogTableViewController, newInfo: String) {
        let index = IndexPath(row:3, section: 2)
        let cell = tableView.cellForRow(at:index) as! studioInfoTableViewCell
        cell.content.text = newInfo
        controller.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    func saveAddAdmin(controller: searchAdminTableViewController,name:String) {

        itemDataSource[4].append(name)
        tableView.reloadData()
    }
    /*
    滑动删除功能
    */
    
}

@objc protocol editTableViewControllerDelegate{
    func saveName(controller:editNameTableViewController, newInfo:String)
    func editNameDidCancer(controller:editNameTableViewController)
    func saveUnit(controller:editUnitTableViewController, newInfo:String)
    func editUnitDidCancer(controller:editUnitTableViewController)
    func saveBlog(controller:editBlogTableViewController, newInfo:String)
    func editBlogDidCancer(controller:editBlogTableViewController)
    func saveIntro(controller:editIntroTableViewController, newInfo:String)
    func editIntroDidCancer(controller:editIntroTableViewController)
    func saveAddAdmin(controller:searchAdminTableViewController,name:String)
}


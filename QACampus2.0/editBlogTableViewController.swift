//
//  editBlogTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/30.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class editBlogTableViewController: editTableViewController {

    var blogString:String?
    var delegate:editTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initButton()
        
        self.view.backgroundColor = sectionHeaderColor
        self.tableView.backgroundColor = sectionHeaderColor
    }
    
    override func initButton() {
        super.initButton()
        cancelBtn.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        saveBtn = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save))
        super.initButton()
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        if section == 2 {
            view.tintColor = sectionHeaderColor
        } else {
            view.tintColor = subTitleBorderColor
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44.0
        } else {
            return 33.0
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell:editBlogTableViewCell = tableView.dequeueReusableCell(withIdentifier: "editBlog", for: indexPath) as! editBlogTableViewCell
            cell.blog.text = blogString
            //            cell.intro.delegate = self
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier:"example",for: indexPath )
            cell.contentView.backgroundColor = sectionHeaderColor
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"space",for: indexPath )
            cell.contentView.backgroundColor = sectionHeaderColor
            return cell
        }
    }
    
}

extension editBlogTableViewController {
    
    func cancel(sender:Any){
        delegate?.editBlogDidCancer(controller:self)
    }
    
    //Ajax请求 保存相应的信息，并返回
    func save(sender:Any) {
        let index = IndexPath(row:0, section: 1)
        let cell = tableView.cellForRow(at:index) as! editBlogTableViewCell
        let txt = cell.blog.text
        delegate?.saveBlog(controller: self, newInfo: txt!)
    }
    
}

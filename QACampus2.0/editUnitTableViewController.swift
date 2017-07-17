//
//  editUnitTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/29.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class editUnitTableViewController: editTableViewController {

    var unitString:String?
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell:editNameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "editName", for: indexPath) as! editNameTableViewCell
            cell.cancelBtn.setImage(UIImage(named:"cancel01"), for: .normal)
            cell.editArea.text = unitString
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"space",for: indexPath )
            cell.contentView.backgroundColor = sectionHeaderColor
            return cell
        }
    }
    
}

extension editUnitTableViewController {
    
    func cancel(sender:Any){
        delegate?.editUnitDidCancer(controller:self)
    }
    
    //Ajax请求 保存相应的信息，并返回
    override func save(sender:Any) {
        let index = IndexPath(row:0, section: 1)
        let cell = tableView.cellForRow(at:index) as! editNameTableViewCell
        let txt = cell.editArea.text
        delegate?.saveUnit(controller: self, newInfo: txt!)
    }
}

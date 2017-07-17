//
//  editIntroTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/30.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class editIntroTableViewController: editTableViewController {

    var introString:String?
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 100.0
        } else {
            return 44.0
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell:editIntroTableViewCell = tableView.dequeueReusableCell(withIdentifier: "editIntro", for: indexPath) as! editIntroTableViewCell
            cell.intro.text = introString
//            cell.intro.delegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"space",for: indexPath )
            cell.contentView.backgroundColor = sectionHeaderColor
            return cell
        }
    }
    
}

extension editIntroTableViewController {
    
    func cancel(sender:Any){
        delegate?.editIntroDidCancer(controller:self)
    }
    
    //Ajax请求 保存相应的信息，并返回
    override func save(sender:Any) {
        let index = IndexPath(row:0, section: 1)
        let cell = tableView.cellForRow(at:index) as! editIntroTableViewCell
        let txt = cell.intro.text
        delegate?.saveIntro(controller: self, newInfo: txt!)
    }

}

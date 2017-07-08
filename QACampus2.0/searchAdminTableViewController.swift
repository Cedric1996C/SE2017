//
//  searchAdminTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/1.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class searchAdminTableViewController: UITableViewController {

    var itemDataSource:[User] = []
    var delegate:editTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .default
        //         view.backgroundColor = .red

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return itemDataSource.count
        return 10
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:searchUserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchUser") as! searchUserTableViewCell
        
        let selector: Selector = #selector(collectBtnClicked)
        let collect = UITapGestureRecognizer(target: self, action: selector)
        collect.numberOfTapsRequired = 1
        cell.addView.addGestureRecognizer(collect)
        cell.addView.tag = indexPath.row
        
//        let item = itemDataSource[indexPath.section][indexPath.row]
//        cell.title.text = item
//        cell.content.text = "点击添加"
//        cell.content.textColor = subTitleBorderColor       
        return cell
    }
    
    func collectBtnClicked(sender:UITapGestureRecognizer){
        let index = IndexPath(row:(sender.view?.tag)!, section: 0)
        let cell = tableView.cellForRow(at:index) as! searchUserTableViewCell
        let view = cell.addView
        
        cell.addLabel.isHidden  = true
        cell.addImage.isHidden = true
        view?.backgroundColor = subTitleBorderColor
        view?.layer.borderColor = whiteColor.cgColor
        
        let label = UILabel()
        view?.addSubview(label)
        label.text = "已添加"
        label.textColor = whiteColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(20)
        })
        
        delegate?.saveAddAdmin(controller: self, name: "abc")
    }
    
}

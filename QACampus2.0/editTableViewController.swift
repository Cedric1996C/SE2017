//
//  editTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/29.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

//定制的edit界面
class editTableViewController: UITableViewController {

    var cancelBtn = UIButton()
    var saveBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
        self.view.backgroundColor = sectionHeaderColor
        self.tableView.backgroundColor = sectionHeaderColor
        
    }
    
    func initButton(){
        
        cancelBtn.setImage(UIImage(named:"back"),for: .normal)
                cancelBtn.setImage(UIImage(named:"cancel02"), for: .selected)
        saveBtn = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveBtn
        
        saveBtn.tintColor = defaultColor
        cancelBtn.tintColor = defaultColor
        
        self.navigationController?.navigationBar.addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints{ make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(10)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        view.tintColor = subTitleBorderColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func save(sender:Any){
        
    }
    
}


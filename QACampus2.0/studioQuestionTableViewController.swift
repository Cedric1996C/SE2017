//
//  studioQuestionTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/13.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class studioQuestionTableViewController: UITableViewController {

    lazy var itemData:[Question] = {
        return []
    }()
    
    lazy var images:[UIImage] = {
        return []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let item=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(returnUser))
        item.tintColor = defaultColor
        self.navigationItem.leftBarButtonItem = item

        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        view.backgroundColor = UIColor(red:255/255,green:235/255,blue:235/255,alpha:1)
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
        return 5
//        return itemData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
        
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studioQuestion", for: indexPath) as! studioQuestionTableViewCell
//        cell.avator.image = images[indexPath.row]
//        let item = itemData[indexPath.row]
//        cell.name.text = item.name
//        cell.date.text = item.date
//        cell.title.text = item.title
//        cell.introduction.text = item.introduction
        // Configure the cell...
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    func returnUser (sender : Any) {
        
    }

}

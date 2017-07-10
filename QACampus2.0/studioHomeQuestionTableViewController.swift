//
//  studioHomeQuestionTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/4.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class studioHomeQuestionTableViewController: UITableViewController {

//     var itemDatasource:studioHomeQuestion
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
        initData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:studioHomeQuestionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "studioHomeQuestion") as! studioHomeQuestionTableViewCell
                //        let item = itemDataSource[indexPath.section][indexPath.row]
        cell.avator.image = UIImage(named:"no.1")
        cell.question.text = "Python是强类型语言吗？"
        cell.byskyler.text = "南大鸽子王"
        return cell
    }
    
    func initData() {
        Alamofire.request("http://localhost:2347/studios" ,method: .get).responseJSON { response in
          
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            var json = JSON(response.result.value)
//            switch response.result {
//            case .success(let value):
//                json = JSON(value)
//                print("JSON: \(json)")
//            case .failure(let error):
//                print(error)
//            }
            
            let list: Array<JSON> = json["content"].arrayValue
            print(list)
        
        }
    }

}

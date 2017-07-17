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
    lazy var itemData:[Question] = {
        return []
    }()
    
    lazy var avators:[Int:UIImage] = {
        return [:]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
        initData()
        
        tableView.backgroundColor = sectionHeaderColor
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:studioHomeQuestionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "studioHomeQuestion") as! studioHomeQuestionTableViewCell
        let item = itemData[indexPath.row]
        let id:Int = item.id!
        cell.avator.image = (avators[id] != nil) ? avators[id]:UIImage(named:"no.1")
//        cell.question.text = item.title
//        cell.byskyler.text = item.name
//        cell.thumbTime.text = String(item.thumbNum)
        cell.question.text = "Python是强类型语言吗？"
        cell.byskyler.text = "南大鸽子王"
        return cell
    }
    
    func initData() {
        Alamofire.request("http://\(root):8443/studios" ,method: .get).responseJSON { response in

            if response.result.value != nil {
                var json = JSON(response.result.value!)
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

}

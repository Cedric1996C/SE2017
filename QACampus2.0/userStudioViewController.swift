//
//  userStudioTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class userStudioViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableData: [Studio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
}

extension userStudioViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
        
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = whiteColor
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //self.navigationController?.pushViewController(DetailViewController(), animated: true)
        performSegue(withIdentifier: "showStudioHome", sender: self)
    }
    
}

extension userStudioViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: userStudioTableViewCell = tableView.dequeueReusableCell(withIdentifier: "userStudio") as! userStudioTableViewCell
        cell.bgimage.image = UIImage(named:"food")
        cell.name.text = tableData[indexPath.row].name
        cell.introduction.text = tableData[indexPath.row].introduction
        return cell
    }
}

extension userStudioViewController {
    
    func initData() {
//        indicator.startAnimating()
        DispatchQueue.global().async {
     
//            Thread.sleep(forTimeInterval: 2)
            Alamofire.request("http://localhost:2347/studios" ,method: .get).responseJSON { response in
                
                // response serialization result
                var json = JSON(response.result.value)
                let list: Array<JSON> = json["content"].arrayValue
                //            print(list)
                for json in list {
                    let name = json["name"].string
                    let introduction = json["introduction"].string
                    var studio = Studio(name: name,introduction: introduction)
                    print(studio.name)
                    self.tableData.append(studio)
                }
                
                self.tableView.reloadData()

            }
            
            DispatchQueue.main.async {
                print(self.tableData.count)
//                self.tableView.reloadData()
//                self.indicator.stopAnimating()
            }
            
        }
    }
    
}

//
//  HotViewController.swift
//  QACampus2.0
//
//  Created by Demons on 2017/5/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import SwiftyJSON

class UserHotViewController: UIViewController {
    
    var tableData: [Abstract] = []
    var nextPage: Int = 0
    var nextPageUrl: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var EnterTeam: UIBarButtonItem!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func EnterTeamBtnPressed(_ sender: UIBarButtonItem) {
        pickerView.isHidden = !pickerView.isHidden
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(UserHotViewController.headerClick))
        tableView.mj_header = header
        
        let footer = MJRefreshBackNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: #selector(UserHotViewController.footerClick))
        tableView.mj_footer = footer
        
        //滑动选择模块
        pickerView.dataSource = self
        pickerView.delegate = self
        
        loadHotData()
        
    }

    func loadHotData() {
        indicator.startAnimating()
        DispatchQueue.global().async {
            // TODO: load data
            authentication()
            let headers: HTTPHeaders = [
                "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMTFAMTYzLmNvbSIsInJvbGVzIjoiW1VTRVJdIiwiaWQiOjIwLCJleHAiOjE1MDEyMzk2MjR9.Ysg43frxTUveFHq2G1mgrbTU1Sd3AJtbVij_RXEiLpoZ_wpe0M4C144FIMdLD-xv16_o347wcMB1w76dVLgbAw"
            ]
            Alamofire.request("https://\(root):8443/qa-service/questions", method: .get, headers: headers).responseJSON { response in
                if let jsonData = response.result.value {
                    let json = JSON(jsonData)
                    let content = json["content"]
                    for item in content {
                        let id = item.1["id"].int
                        let vote = item.1["thumb"].int
                        let title = item.1["question"].string
                        let description = item.1["describtion"].string
                        self.tableData.append(Abstract(id: id, count: vote, title: title, detail: description))
                    }
                    let isLast = json["last"].boolValue
                    if !isLast {
                        self.nextPageUrl = "https://\(root):8443/\(json["_links"]["next"]["href"].stringValue)"
                    }
                    else {
                        self.nextPageUrl = ""
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func headerClick() {
        // 可在此处实现下拉刷新时要执行的代码
        // ......
        
        self.tableData.removeAll()
        tableView.mj_footer.resetNoMoreData()
        loadHotData()
        
        // 结束刷新
        tableView.mj_header.endRefreshing()
    }
    
    func footerClick () {
        // 可在此处实现上拉加载时要执行的代码
        // ......
        
        if nextPageUrl.isEmpty {
            tableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
        DispatchQueue.global().async {
            // TODO: load data
            authentication()
            let headers: HTTPHeaders = [
                "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMTFAMTYzLmNvbSIsInJvbGVzIjoiW1VTRVJdIiwiaWQiOjIwLCJleHAiOjE1MDEyMzk2MjR9.Ysg43frxTUveFHq2G1mgrbTU1Sd3AJtbVij_RXEiLpoZ_wpe0M4C144FIMdLD-xv16_o347wcMB1w76dVLgbAw"
            ]
            Alamofire.request(self.nextPageUrl, method: .get, headers: headers).responseJSON { response in
                if let jsonData = response.result.value {
                    let json = JSON(jsonData)
                    let content = json["content"]
                    for item in content {
                        let id = item.1["id"].int
                        let vote = item.1["thumb"].int
                        let title = item.1["question"].string
                        let description = item.1["describtion"].string
                        self.tableData.append(Abstract(id: id, count: vote, title: title, detail: description))
                    }
                    let isLast = json["last"].boolValue
                    if !isLast {
                        self.nextPageUrl = "https://\(root):8443/\(json["_links"]["next"]["href"].stringValue)"
                    }
                    else {
                        self.nextPageUrl = ""
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                    }
                }
            }
        }
        
        // 结束刷新
        tableView.mj_footer.endRefreshing()
    }

    
}

extension UserHotViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        performSegue(withIdentifier: "TMP", sender: self)
        return false
    }
    
}

extension UserHotViewController: UITableViewDelegate {
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Detail.id = tableData[indexPath.row].id
        Detail.title = tableData[indexPath.row].title
        //self.navigationController?.pushViewController(DetailViewController(), animated: true)
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }*/
}

extension UserHotViewController: UITableViewDataSource {
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserHotTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! UserHotTableViewCell
        cell.title.text = self.tableData[indexPath.row].title
        cell.detail.text = self.tableData[indexPath.row].detail
        cell.count.text = String(self.tableData[indexPath.row].count)
        return cell
    }
}

extension UserHotViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "TEST"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
}

extension UserHotViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let width = self.view.frame.width
        let height = self.view.frame.height        
        let userVc =  UIStoryboard.init(name: "StudioTab", bundle: nil).instantiateInitialViewController()
        userVc!.view.frame = CGRect(x:0, y:0,width: width, height:height)
        self.present(userVc!, animated: true, completion: nil)

    }
}

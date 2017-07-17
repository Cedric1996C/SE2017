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
                "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4Mzc5NDA1OTNAcXEuY29tIiwicm9sZXMiOiJbVVNFUl0iLCJpZCI6MSwiZXhwIjoxNTAwMzYzOTc2fQ.UUWxPoQyf99bwV7vuGVXqVNobEoS2eWOWpqt_Mm_AzNT9lcgWTjNEbOwym4KRVGCMFrLk5vzZFRtyr4jC3N9yg"
            ]
            Alamofire.request("https://118.89.166.180:8443/qa-service/questions", method: .get, headers: headers).responseJSON { response in
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
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                    }
                }
            }
            /*Thread.sleep(forTimeInterval: 2)
            self.tableData = [
                Abstract(count: 63, title: "Python是强类型语言吗？", detail: "Python定义变量不显式指定类型，为什么…"),
                Abstract(count: 7, title: "为什么这么多人用Java？", detail: "我感觉Java很繁琐，为什么工业界似乎还…"),
                Abstract(count: 15, title: "C++在什么领域用得比较多？", detail: "现在在学C++，但是不知道C++今后会在什…"),
                Abstract(count: 23, title: "这个title很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长", detail: "一个detail"),
            ]*/
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func headerClick() {
        // 可在此处实现下拉刷新时要执行的代码
        // ......
        
        
        // 模拟延迟3秒
        Thread.sleep(forTimeInterval: 2)
        // 结束刷新
        tableView.mj_header.endRefreshing()
    }
    
    func footerClick () {
        // 可在此处实现上拉加载时要执行的代码
        // ......
        
        
        // 模拟延迟3秒
        Thread.sleep(forTimeInterval: 2)
        // 结束刷新
        tableView.mj_footer.endRefreshing()
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
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
        Detail.title = String(repeating: tableData[indexPath.row].title, count: 3)
        Detail.detail = String(repeating: tableData[indexPath.row].detail, count: 10)
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

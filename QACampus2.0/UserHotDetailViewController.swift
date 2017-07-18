//
//  DetailViewController.swift
//  QACampus2.0
//
//  Created by Eric Wen on 2017/6/2.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class UserHotDetailViewController: UITableViewController {
    
    var answerList: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        requestData()
    }
    
    func requestData() {
        DispatchQueue.global().async {
            // TODO: load data
            authentication()
            let headers: HTTPHeaders = [
                "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMTFAMTYzLmNvbSIsInJvbGVzIjoiW1VTRVJdIiwiaWQiOjIwLCJleHAiOjE1MDEyMzk2MjR9.Ysg43frxTUveFHq2G1mgrbTU1Sd3AJtbVij_RXEiLpoZ_wpe0M4C144FIMdLD-xv16_o347wcMB1w76dVLgbAw"
            ]
            Alamofire.request("https://\(root):8443/qa-service/questions/\(Detail.id)", method: .get, headers: headers).responseJSON { response in
                if let jsonData = response.result.value {
                    let json = JSON(jsonData)
                    Detail.title = json["question"].stringValue
                    Detail.detail = json["describtion"].stringValue
                    let answer = json["answer"].arrayValue
                    for ans in answer {
                        self.answerList.append(Answer(id: 0, str: ans["details"].string))
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return answerList.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: UserHotDetailContentCell = self.tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! UserHotDetailContentCell
            cell.titleLabel.text = Detail.title
            cell.detailLabel.text = Detail.detail
            cell.titleLabel.sizeToFit()
            cell.detailLabel.sizeToFit()
            return cell
        }
        else {
            /*let cell: UserHotDetailCommentCell = self.tableView.dequeueReusableCell(withIdentifier: "commentCell") as! UserHotDetailCommentCell
            cell.commentLabel.text = String(repeating: "这是评论", count: 100)
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            //cell.timeLabel.text = formatter.string(from: Date())
            cell.timeLabel.text = ""
            cell.userIdButton.sizeToFit()
            cell.timeLabel.sizeToFit()
            cell.commentLabel.sizeToFit()
            return cell*/
            let cell: UserHotDetailAnswerCell = self.tableView.dequeueReusableCell(withIdentifier: "AnswerCell") as! UserHotDetailAnswerCell
            cell.answerLabel.text = answerList[indexPath.row].str
            cell.answerLabel.sizeToFit()
            return cell
        }
    }
    
    func configLabelSize(_ label: UILabel) -> CGSize {
        return CGSize()
    }
    
}

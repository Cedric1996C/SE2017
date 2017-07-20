//
//  topicDetailTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class topicDetailTableViewController: UITableViewController {

    lazy var comments:[Comment] = {
        return []
    }()
    
    override func loadView() {
        super.loadView()
        //tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    // MARK: - Table view data source
//    override func viewWillAppear(_ animated: Bool) {
//        let headers: HTTPHeaders = [
//            "Authorization": userAuthorization
//        ]
//        Alamofire.request("https://\(root):8443/topic-service/topic/\(TopicDetail.id)", method: .get, headers: headers).responseJSON { response in
//            if let json = response.result.value {
//                print(json)
//                let jsonObj = JSON(data: response.data!)
//                
//                let studioId:Int = jsonObj["content"]["studio"].intValue
//                //加载studioName
//                //TopicDetail.studio =
//               //                    
//                //
//                TopicDetail.title = jsonObj["content"]["title"].stringValue
//                //时间戳／ms转为/s
//                let dateStamp = jsonObj["content"]["date"].intValue/1000
//                // 时间戳转字符串
//                TopicDetail.date = date2String(dateStamp: dateStamp)
//                
//                    
//                TopicDetail.thumbNum = jsonObj["content"]["thumb_num"].intValue
//            }
//        }
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section != 4 {
            return 1
        } else {
//            return comments.count
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell:UITableViewCell?
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicTitle", for: indexPath) as! topicTitleTableViewCell
            cell.title.text = TopicDetail.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicStudio", for: indexPath) as! topicStudioTableViewCell
            cell.authorAvator.image = TopicDetail.authorAvator
            cell.name.text = TopicDetail.authorName
            cell.studioName.text = TopicDetail.studio
            cell.date.text = TopicDetail.date
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicContent", for: indexPath) as! topicContentTableViewCell
            //TODO: cell.topicDetailLabel.text = ...
            cell.topicDetailLabel.sizeToFit()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicSeperate", for: indexPath) as! topicSeperateTableViewCell
            cell.commentNum.text = String(TopicDetail.thumbNum)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicComment", for: indexPath) as! topicCommentTableViewCell
            cell.content.text = "这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长这个话题很长很长"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicComment", for: indexPath) as! topicCommentTableViewCell
            return cell
        }

    }
    

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch  indexPath.section {
        case 0:
            return 60.0
        case 1:
            return 80.0
        case 2:
            return 100.0
        case 3:
            return 40.0
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicComment", for: indexPath) as! topicCommentTableViewCell
            return cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        default:
            return 80.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section{
        case 1:
            return 1.0
        case 2:
            return 2.0
        case 3:
            return 2.0
        case 4:
            return 1.0
        default:
            return 0
        }
    }

//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.backgroundColor = sectionHeaderColor
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


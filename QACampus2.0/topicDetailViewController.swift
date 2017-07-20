//
//  topicDetailViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class topicDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var topic: UITableView!
    
    lazy var comments:[Comment] = {
        return []
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topic.rowHeight = UITableViewAutomaticDimension
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        topic.estimatedRowHeight = 300
        topic.separatorStyle = .none
        topic.dataSource = self
        topic.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        let headers: HTTPHeaders = [
                    "Authorization": userAuthorization
                ]
        Alamofire.request("https://\(root):8443/topic-service/topic/\(TopicDetail.id)", method: .get, headers: headers).responseJSON { response in
            if let json = response.result.value {
                print(json)
                let jsonObj = JSON(data: response.data!)
                
                let studioId:Int = jsonObj["content"]["studio"].intValue
                //加载studioName
                //TopicDetail.studio =
                //加载头像
                
                //
                TopicDetail.title = jsonObj["content"]["title"].stringValue
                //时间戳／ms转为/s
                let dateStamp = jsonObj["content"]["date"].intValue/1000
                // 时间戳转字符串
                TopicDetail.date = date2String(dateStamp: dateStamp)
                
                
                TopicDetail.thumbNum = jsonObj["content"]["thumb_num"].intValue
                self.topic.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section != 4 {
            return 1
        } else {
            //            return comments.count
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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

}

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
    
    @IBAction func addComment(_ sender: Any) {
        performSegue(withIdentifier: "ToComment", sender: nil)
    }
    
    @IBAction func addFav(_ sender: Any) {
        DispatchQueue.global().async {
            authentication()
            let headers: HTTPHeaders = [
                "Authorization": userAuthorization,
                "topic": String(TopicDetail.id)
            ]
            Alamofire.request("https://\(root):8443/owner-service/owners/\(User.localUserId!)/topic/collect", method: .post, headers: headers).responseJSON { response in
                if let jsonData = response.result.value {
                    let ac = UIAlertController(title: "收藏成功", message: nil, preferredStyle: .alert)
                    self.present(ac, animated: true, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: (UInt64)(2 * NSEC_PER_SEC))) {
                        ac.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topic.rowHeight = UITableViewAutomaticDimension
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        topic.estimatedRowHeight = 300
        topic.separatorStyle = .none
        topic.dataSource = self
        topic.delegate = self
        loadData()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"返回", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem?.tintColor = iconColor
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
            return comments.count
//            return 1
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
            cell.studioName.text = ""
            cell.date.text = TopicDetail.date
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicContent", for: indexPath) as! topicContentTableViewCell
            // TODO: cell.topicDetailLabel.text = ...
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "topicSeperate", for: indexPath) as! topicSeperateTableViewCell
            cell.commentNum.text = String(comments.count)
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
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadData(){
        
        let headers: HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        Alamofire.request("https://\(root):8443/topic-service/topic/\(TopicDetail.id)", method: .get, headers: headers).responseJSON { response in
            if let jsonData = response.result.value {
                let json = JSON(jsonData)["content"].arrayValue[0]
//                print(json)
                TopicDetail.id = json["id"].intValue
                TopicDetail.title = json["title"].stringValue
                TopicDetail.date = date2String(dateStamp:(json["date"].intValue/1000))
                
                let writer_id = json["writer"].intValue
                
                // TODO: get data
                let path:String = "topic/\(TopicDetail.id)/\(writer_id)/topic"
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileURL = documentsURL.appendingPathComponent(path)
                    
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                
                //请求用户的信息
                Alamofire.request("https://\(root):8443/owner-service/owners/\(writer_id)", method: .get,headers: headers).responseJSON { response in
                    
                    if  response.result.value != nil {
                        if (response.response?.statusCode)! == 200 {
                            let userJSON = JSON(response.result.value!)
                            TopicDetail.authorName = userJSON["display_name"].stringValue
                        }
                    }
                    self.topic.reloadData()
                }
                
                //请求用户的头像
                Alamofire.request(storageRoot+"user/\(writer_id)", method: .get).responseJSON { response in
                    
                    if response.response?.statusCode == 200 {
                        let json = response.result.value
                        //                print(json)
                        if let pictures:[String] = json as! [String] {
                            let pic_path = "user/\(writer_id)".appending("/" + pictures[0])
                            print(pic_path)
                            //获取文件
                            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                let fileURL = documentsURL.appendingPathComponent(pic_path)
                                
                                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                            }
                            
                            Alamofire.download(uploadRoot + pic_path, to: destination).response { response in
                                if response.error == nil, let imagePath = response.destinationURL?.path {
                                    TopicDetail.authorAvator = getPicture(pic_path)
                                    self.topic.reloadData()
                                }
                            }
                        }
                    }
                }

                
                Alamofire.download(uploadRoot+path, to: destination).response { response in
                    
                    if response.error == nil {
                        let data = getQuestion(path)
                        print(data)
                        //异步加载 使用data应在这个上下文里面
                        self.topic.reloadData()
                    }
                }
                // Detail.questionDetailAttr = NSKeyedUnarchiver.unarchiveObject(with: data) as NSAttributedString
                
                let comment = json["comment"].arrayValue
                for com in comment {
                    print(com)
                    
                    let id = com["writer"].intValue
                    let detail = com["content"].stringValue
                    let date = date2String(dateStamp:com["date"].intValue/1000)
                    //                    let writer = com["writer"].intValue
                    let result = Comment(id: id,introduction:detail)
                    self.comments.append(result)
                    
                    let path = "user/\(id)"
                    print(path)
                    
                    let headers:HTTPHeaders = [
                        "Authorization":userAuthorization
                    ]
                    
                    //请求用户的信息
                    Alamofire.request("https://\(root):8443/owner-service/owners/\(id)", method: .get,headers: headers).responseJSON { response in
                        
                        if  response.result.value != nil {
                            if (response.response?.statusCode)! == 200 {
                                let userJSON = JSON(response.result.value!)
                                result.name = userJSON["display_name"].string
                            }
                        }
                        self.topic.reloadData()
                    }
                    
                    //请求用户的头像
                    Alamofire.request(storageRoot+path, method: .get).responseJSON { response in
                        
                        if response.response?.statusCode == 200 {
                            let json = response.result.value
                            //                print(json)
                            if let pictures:[String] = json as! [String] {
                                let pic_path = path.appending("/" + pictures[0])
                                print(pic_path)
                                //获取文件
                                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                    let fileURL = documentsURL.appendingPathComponent(pic_path)
                                    
                                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                                }
                                
                                Alamofire.download(uploadRoot + pic_path, to: destination).response { response in
                                    if response.error == nil, let imagePath = response.destinationURL?.path {
                                        result.avator = getPicture(pic_path)
                                        self.topic.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            self.topic.reloadData()
        }
    }
}

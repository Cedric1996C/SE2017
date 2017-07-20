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
        cell.question.text = item.title
        cell.thumbTime.text = String(describing: item.thumb_num!)
        cell.answer_num.text = "\(item.answer_num!)位答主回答了此问题"
        cell.date.text = item.date
        return cell
    }
    
    func initData() {
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        Alamofire.request("https://\(root):8443/qa-service/questions/\(LocalStudio.id)/answered" ,method: .get,headers: headers).responseJSON { response in
            
            print(response.result.value!)
            if response.response?.statusCode == 200 && response.result.value != nil {
                // response serialization result
                var json = JSON(response.result.value!)
                let list: Array<JSON> = json.arrayValue
                
                for json in list {
                    let list: Array<JSON> = json["answer"].arrayValue
                    let answer_num:Int = list.count
                    let id:Int = json["id"].int!
                    let title = json["question"].string
                    let name = json["asker"].int!
                    let introduction = json["describtion"].string
                    let dateStamp = json["date"].intValue/1000
                    let date:String = date2String(dateStamp: dateStamp)
                    
                    let result = Question(id:id, name:"", date: date, title: title!, introduction:introduction!, answer_num:answer_num)
                    let thumb_num:Int = json["thumb"].int!
                    result.thumb_num = thumb_num
                    
                    Alamofire.request("https://\(root):8443/owner-service/owners/\(name)" ,method: .get,headers: headers).responseJSON { response in
                        if response.response?.statusCode == 200 {
                            let json = JSON(response.result.value!)
                            let name = json["display_name"].string
                            result.name = name!
                            self.itemData.append(result)
                        }
                        let path:String = "user/\(name)"
                        //请求客户端的文件路径下的文件
                        Alamofire.request(storageRoot+path, method: .get).responseJSON { response in
                            if let json = response.result.value {
                                
                                if response.response?.statusCode == 200 {
                                    let pictures:[String] = json as! [String]
                                    let pic_path = path.appending("/" + pictures[0])
                                    
                                    //获取文件
                                    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                        let fileURL = documentsURL.appendingPathComponent(pic_path)
                                        
                                        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                                    }
                                    Alamofire.download(uploadRoot+pic_path, to: destination).response { response in
                                        
                                        if response.error == nil, let imagePath = response.destinationURL?.path {
                                            self.avators[id] = getPicture(pic_path)
                                            self.reload()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}

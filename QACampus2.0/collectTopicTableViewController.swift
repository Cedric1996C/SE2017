//
//  collectTopicTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class collectTopicTableViewController: collectQuestionTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemData.count
    }

}

extension collectTopicTableViewController {
    
    override func initData(){
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        Alamofire.request("https://\(root):8443/topic-service/topic/\(User.localUserId!)/topic/collect" ,method: .get,headers: headers).responseJSON { response in
            
            if (response.response?.statusCode)! == 200 {
                // response serialization result
                var json = JSON(response.result.value!)
                let list: Array<JSON> = json.arrayValue
                
            
                for json in list {
                    let id:Int = json["id"].int!
                    let title = json["title"].string
                    let writer_id:Int = json["writer"].int!
                    let introduction = json["content"].string
                    //时间戳／ms转为/s
                    let dateStamp = json["date"].intValue/1000
                    // 时间戳转字符串
                    let date:String = date2String(dateStamp: dateStamp)
                    
                    let path:String = "user/\(writer_id)"
                    
                    //请求客户端的文件路径下的文件
                    Alamofire.request("https://localhost:6666/files/\(path)", method: .get).responseJSON { response in
                        
                        if response.response?.statusCode == 200 {
                            if let json = response.result.value {
                                print(json)
                                let pictures:[String] = json as! [String]
                                let pic_path = path.appending("/" + pictures[1])
                                
                                //获取文件
                                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                    let fileURL = documentsURL.appendingPathComponent(pic_path)
                                    
                                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                                }
                                Alamofire.download("https://localhost:6666/\(pic_path)", to: destination).response { response in
                                    
                                    if response.error == nil, let imagePath = response.destinationURL?.path {
                                        self.avators[id] = getPicture(pic_path)
                                        self.reload()
                                    }
                                }
                            }
                        }
                    }
                    
                    //根据id获取writer的姓名
                    Alamofire.request("https://\(root):8443/owner-service/owners/\(writer_id)" ,method: .get,headers: headers).responseJSON { response in

                        if response.response?.statusCode == 200 {
                            var json = JSON(response.result.value!)
                            let name:String = json["display_name"].string!
                            let id:Int = json["id"].int!
                            
                            let result = Result(id:id, name:name, time:date ,title: title!,desc:introduction! )
                            self.itemData.append(result)
                            self.reload()
                        }
                    }
                    
                }
            }
        }
        
    }
}

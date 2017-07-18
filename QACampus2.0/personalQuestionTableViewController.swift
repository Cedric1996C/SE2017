//
//  personalQuestionTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class personalQuestionTableViewController: collectQuestionTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension personalQuestionTableViewController {
    
    override func initData(){
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        Alamofire.request("https://\(root):8443/qa-service/questions/\(User.localUserId!)/question" ,method: .get,headers: headers).responseJSON { response in
            print((response.response?.statusCode)!)
            //根据用户id拉问题列表
            if (response.response?.statusCode)! == 200 {
                // response serialization result
                var json = JSON(response.result.value!)
                let list: Array<JSON> = json.arrayValue
                for json in list {
                    let id:Int = json["id"].int!
                    let title = json["question"].string
                    let name = json["studio"].int!
                    let introduction = json["describtion"].string
                    
                    let dateStamp = json["date"].intValue/1000
                    let date:String = date2String(dateStamp: dateStamp)
                    
                    let result = Result(id:id, name:"", time: date, title: title!, desc:introduction!)
                    
                    Alamofire.request("https://\(root):8443/owner-service/owners/\(name)" ,method: .get,headers: headers).responseJSON { response in
                        
                        if response.response?.statusCode == 200 && (response.result.value != nil){
                            let json = JSON(response.result.value!)
                            print(name)
                            print(json)
                            let display_name = json["display_name"].string
                            result.name = (display_name != nil) ? display_name! : ""
                            self.itemData.append(result)
                        }
                        
                        let path:String = "studio/\(name)"
                        //请求客户端的文件路径下的文件
                        Alamofire.request("https://localhost:6666/files/\(path)", method: .get).responseJSON { response in
                            if let json = response.result.value {
                                
                                //是否存在该用户的文件目录
                                if response.response?.statusCode == 200 {
                                    let pictures:[String] = json as! [String]
                                    let pic_path = path.appending("/" + pictures[0])
                                    
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
                    }
                    
                }
            }
        }
        
    }

}

//
//  collectQuestionTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class collectQuestionTableViewController: editPersonalTableViewController {

    lazy var itemData:[Result] = {
       return []
    }()
    
    lazy var avators:[Int:UIImage] = {
        return [:]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
        initData()
        tableView.rowHeight = UITableViewAutomaticDimension
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableView.estimatedRowHeight = 300
        
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemData.count    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectQuestion", for: indexPath) as! collectQuestionTableViewCell
        let result:Result = itemData[indexPath.row]
        cell.title.text = result.title
        cell.date.text = result.time
        cell.name.text = result.name
        cell.introduction.text = result.desc
        cell.avator.image = (avators[result.id] != nil) ? avators[result.id]:UIImage(named: "no.1")
        return cell
    }

    func cancel(sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func reload() {
        self.tableView.reloadData()
    }


}

extension collectQuestionTableViewController {
    
    func initData(){
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        
        Alamofire.request("https://\(root):8443/qa-service/questions/\(User.localUserId!)/question/collect" ,method: .get,headers: headers).responseJSON { response in
            
            if (response.response?.statusCode)! == 200 {
                // response serialization result
                var json = JSON(response.result.value!)
                let list: Array<JSON> = json.arrayValue
            
                    for json in list {
                        let id:Int = json["id"].int!
                        let title = json["question"].string
                        let name = json["asker"].int!
                        let introduction = json["describtion"].string
                        
                        let dateStamp = json["date"].intValue/1000
                        let date:String = date2String(dateStamp: dateStamp)
                        
                        let result = Result(id:id, name:"", time: date, title: title!, desc:introduction!)
                        
                        Alamofire.request("https://\(root):8443/owner-service/owners/\(name)" ,method: .get,headers: headers).responseJSON { response in
                            if response.response?.statusCode == 200 {
                                let json = JSON(response.result.value!)
                                let name = json["display_name"].string
                                result.name = name!
                                self.itemData.append(result)
                            }
                        }
                        let path:String = "user/\(name)"
                        print(name)
                        //请求客户端的文件路径下的文件
                        Alamofire.request("https://localhost:6666/files/\(path)", method: .get).responseJSON { response in
                            if let json = response.result.value {
                                
                                if response.response?.statusCode == 200 {
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
                }
            }
        }
        
    }
}

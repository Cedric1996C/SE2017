//
//  personalStudioViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import  SwiftyJSON

class collectStudioViewController: collectQuestionTableViewController {

    lazy var studios:[Studio] = {
        return []
    }()
    
    lazy var backgrounds:[Int:UIImage] = {
        return [:]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:255/255,green:235/255,blue:235/255,alpha:1)
       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectStudio", for: indexPath) as! collectStudioCell
        let studio:Studio = studios[indexPath.row]
        cell.name.text = studio.name
        cell.introduction.text = studio.introduction
        cell.picture.image = (backgrounds[studio.id!] != nil) ? backgrounds[studio.id!]:UIImage(named:"food")
        cell.avator.image = (avators[studio.id!] != nil) ? avators[studio.id!]:UIImage(named: "no.1")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }

    override func cancel(sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension collectStudioViewController {
   
    override func initData(){
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        Alamofire.request("https://\(root):8443/studio-service/studios" ,method: .get,headers: headers).responseJSON { response in
            
            // response serialization result
            var json = JSON(response.result.value!)
            let list: Array<JSON> = json["content"].arrayValue
            
            for json in list {
                let name = json["name"].string
                let introduction = json["introduction"].string
                let id:Int = json["id"].int!
                let studio = Studio(id:id ,name: name,introduction: introduction)
                let path:String = "studio/\(id)"                
                self.studios.append(studio)
                //请求客户端的文件路径下的文件
                Alamofire.request("https://localhost:6666/files/\(path)", method: .get).responseJSON { response in
                    if let json = response.result.value {
                        let pictures:[String] = json as! [String]
                        let avator_path = path.appending("/" + pictures[1])
                        let background_path = path.appending("/" + pictures[2])
                        
                        //获取文件
                        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileURL = documentsURL.appendingPathComponent(avator_path)
                            
                            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                        }
                        Alamofire.download("https://localhost:6666/\(avator_path)", to: destination).response { response in
                            
                            if response.error == nil, let imagePath = response.destinationURL?.path {
                                self.avators[id] = getPicture(avator_path)
                                self.reload()
                            }
                        }
                        //获取文件
                        let bg_destination: DownloadRequest.DownloadFileDestination = { _, _ in
                            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileURL = documentsURL.appendingPathComponent(background_path)
                            
                            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                        }
                        Alamofire.download("https://localhost:6666/\(background_path)", to: bg_destination).response { response in
                            
                            if response.error == nil, let imagePath = response.destinationURL?.path {
                                self.backgrounds[id] = getPicture(background_path)
                                self.reload()
                            }
                        }
                    }
                }
            }
        }
    }
}

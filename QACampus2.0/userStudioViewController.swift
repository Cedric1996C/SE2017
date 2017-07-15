//
//  userStudioTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/5.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class userStudioViewController: UIViewController {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var tableData: [Studio] = []
    var images:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.startAnimating()
        
        authentication()
        
        tableView.dataSource = self
        tableView.delegate = self
        initData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
}

extension userStudioViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
        
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = whiteColor
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //self.navigationController?.pushViewController(DetailViewController(), animated: true)
        let studio:Studio = tableData[indexPath.row]
        SingletonStudio.id = studio.id!
        SingletonStudio.title = studio.name!
        SingletonStudio.introduction = studio.introduction!
        //头像下载
        let path = "studio/\(SingletonStudio.id)"
        Alamofire.request("https://localhost:6666/files/\(path)", method: .get).responseJSON { response in
            if let json = response.result.value {
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
                        SingletonStudio.avator = UIImage(contentsOfFile: imagePath)!
                        self.performSegue(withIdentifier: "showStudioInfo", sender: self)
                    }
                }
            }
        }
    }

}

extension userStudioViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: userStudioTableViewCell = tableView.dequeueReusableCell(withIdentifier: "userStudio") as! userStudioTableViewCell
        cell.bgimage.image = (images[indexPath.row] != nil) ? images[indexPath.row]:#imageLiteral(resourceName: "food")
        cell.name.text = tableData[indexPath.row].name
        cell.introduction.text = tableData[indexPath.row].introduction
        return cell
    }
}

extension userStudioViewController {
    
    func initData() {

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
             
                self.tableData.append(studio)
                //请求客户端的文件路径下的文件
                Alamofire.request("https://localhost:6666/files/\(path)", method: .get).responseJSON { response in
                    if let json = response.result.value {
                        let pictures:[String] = json as! [String]
                        let pic_path = path.appending("/" + pictures[2])
                        
                        //获取文件
                        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let fileURL = documentsURL.appendingPathComponent(pic_path)
                            
                            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                        }
                        Alamofire.download("https://localhost:6666/\(pic_path)", to: destination).response { response in
                            
                            if response.error == nil, let imagePath = response.destinationURL?.path {
                                self.images.append(getPicture(pic_path))
                                self.reload()
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

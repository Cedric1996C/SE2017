//
//  GetPicture.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/13.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import Alamofire

//图片下载
func downloadPicture(_ path:String,id:Int){
    
    Alamofire.request("https://localhost:6666/files/\(path)", method: .get).responseJSON { response in
        if let json = response.result.value {
            let pictures:[String] = json as! [String]
            let pic_path = path.appending("/" + pictures[1])
            print(pic_path)
        }
    }
}


//MARK: - 保存图片至沙盒
func saveImage(currentImage:UIImage,path:String){
    
    var imageData = NSData()
    imageData = UIImageJPEGRepresentation(currentImage, 1.0)! as NSData
    // 获取沙盒目录
    print(path)
    let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(path)
    print(fullPath)
    // 将图片写入文件
    imageData.write(toFile: fullPath, atomically: false)
    
}

//从沙盒中取出文件
func getPicture(_ path:String) -> UIImage {
    
    let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(path)
    print(fullPath)
    return UIImage(contentsOfFile: fullPath)!
    
}

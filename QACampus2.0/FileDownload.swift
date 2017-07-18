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
func downloadQuestion(_ path:String){
   
    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(path)
        
        return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    Alamofire.download(uploadRoot+path, to: destination).response { response in
        
        if response.error == nil, let data = response.destinationURL?.path {
//            print(data)
        }
        
        debugPrint(response)
        
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
    if let image = UIImage(contentsOfFile: fullPath) {
        return image
    } else {
        return UIImage(named:"no.1")!
    }
    
}

//
//  FileStorage.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CryptoSwift

//直接调用，参数为文件的路径:String,返回的认证token以键值对形式存储于储存在 fileAuthirization[String:String] 中
func prepareForStorage(_ path: String,destination:String) {
    
    let currentImage = UIImage(contentsOfFile: path)!
    let data = UIImageJPEGRepresentation(currentImage, 1.0)
    let hash = data?.md5()
    let md5:String = (hash?.toHexString())!
    print(md5)
    
    let headers:HTTPHeaders = [
        "Authorization": userAuthorization
    ]
    let parameters:Parameters = ["md5": md5]
    Alamofire.request("https://\(root):8443/storage/" ,method: .post, parameters:parameters,headers: headers).responseJSON { response in
        
        if let headers = response.response?.allHeaderFields as? [String: String]{
            fileAuthirization[path] = headers["Authorization"]!
        }
        
        // response serialization result
        fileUpload(path,destination: destination)
    }

}

func fileUpload(_ path: String,destination:String) {
    
    print("开始上传")
    let currentImage = UIImage(contentsOfFile: path)!
    let data = UIImageJPEGRepresentation(currentImage, 1.0)
    let imageName = String(describing: "avator.png")
    print(imageName)
    
    let headers:HTTPHeaders = [
        "Authorization":fileAuthirization[path]!
    ]
    
    Alamofire.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append(data!, withName: "file", fileName: imageName, mimeType: "image/png")
    
    },
        to: destination, headers:headers,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
    })

}

func prepareFile(_ path: String,destination:String) {
   
    let userDefault = UserDefaults.standard
    let data = userDefault.data(forKey: path)
    print(data!)
    let hash = data?.md5()
    let md5:String = (hash?.toHexString())!
    print(md5)
    
    let headers:HTTPHeaders = [
        "Authorization": userAuthorization
    ]
    let parameters:Parameters = ["md5": md5]
    
    Alamofire.request("https://\(root):8443/storage/" ,method: .post, parameters:parameters,headers: headers).responseJSON { response in
        
        debugPrint(response)
        if let headers = response.response?.allHeaderFields as? [String: String]{
            fileAuthirization[path] = headers["Authorization"]!
        }
        
        // response serialization result
        FileUpload(path,destination: destination)
    }
    
}

func FileUpload(_ path: String,destination:String) {
    
    print("开始上传")
    let userDefault = UserDefaults.standard
    let data = userDefault.data(forKey: path)
    let dataName = String(describing: "question")
    print(dataName)
    
    let headers:HTTPHeaders = [
        "Authorization":fileAuthirization[path]!
    ]
    
    Alamofire.upload(
        multipartFormData: { multipartFormData in
            multipartFormData.append(data!, withName: "file", fileName: dataName, mimeType: "text/plain")
            
    },
        to: destination, headers:headers,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
    })
    
}

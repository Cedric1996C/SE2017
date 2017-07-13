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

func fileMD5(_ path: String) -> String? {
   
//    let currentImage = UIImage(contentsOfFile: path)!
    let handle = FileHandle(forReadingAtPath: path)
    print(handle)
    if handle == nil {
        return nil
    }
    
    let ctx = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: MemoryLayout<CC_MD5_CTX>.size)
    
    CC_MD5_Init(ctx)
    
    var done = false
    
    while !done {
        let fileData = handle?.readData(ofLength: 256)
        
        fileData?.withUnsafeBytes {(bytes: UnsafePointer<CChar>)->Void in
            //Use `bytes` inside this closure
            //...
            CC_MD5_Update(ctx, bytes, CC_LONG(fileData!.count))
        }
        
        if fileData?.count == 0 {
            done = true
        }
    }
    
    //unsigned char digest[CC_MD5_DIGEST_LENGTH];
    let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
    CC_MD5_Final(digest, ctx);
    
    var hash = ""
    for i in 0..<digestLen {
        hash +=  String(format: "%02x", (digest[i]))
    }
    
    digest.deinitialize()
    ctx.deinitialize()
    
    return hash;
    
}

//直接调用，参数为文件的路径:String,返回的认证token以键值对形式存储于储存在 fileAuthirization[String:String] 中
func prepareForStorage(_ path: String) {
    
//    let hash1:String = fileMD5(path)!
    let currentImage = UIImage(contentsOfFile: path)!
    let data = UIImageJPEGRepresentation(currentImage, 1.0)
    let hash = data?.md5()
    let md5:String = (hash?.toHexString())!
    print(md5)
    
    let headers:HTTPHeaders = [
        "Authorization": userAuthorization
    ]
    let parameters:Parameters = ["md5": md5]
    Alamofire.request("https://\(root):8443/storage" ,method: .post, parameters:parameters,headers: headers).responseJSON { response in
        
        if let headers = response.response?.allHeaderFields as? [String: String]{
            fileAuthirization[path] = headers["Authorization"]!
        }
        // response serialization result
        fileUpload(path)
    }

}

func fileUpload(_ path: String) {
    
//    let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(path)
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
//                multipartFormData.append(rainbowImageURL, withName: "rainbow")
    },
        to: "https://localhost:6666/1/demo", headers:headers,
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

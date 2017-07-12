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

func fileMD5(_ path: String) -> String? {
    
    let handle = FileHandle(forReadingAtPath: path)
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

//直接调用，参数为文件的路径:String,返回的认证token储存在 fileAuthirization 中
func prepareForStorage(_ path: String) {
    
    let hash:String = fileMD5(path)!
    
    let headers:HTTPHeaders = [
        "Authorization": userAuthorization
    ]
    var header:String!
    let parameters:Parameters = ["md5": hash]
    Alamofire.request("https://\(root):8443/storage" ,method: .post, parameters:parameters,headers: headers).responseJSON { response in
        
        if let headers = response.response?.allHeaderFields as? [String: String]{
            fileAuthirization = headers["Authorization"]!
        }
        // response serialization result
    }

}

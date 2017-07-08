//
//  editAvator.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/30.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

//编辑头像
extension editStudioInfoTableViewController {
    //选择头像的函数
    func selectIcon(){
        let userIconAlert = UIAlertController(title: "请选择操作", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let chooseFromPhotoAlbum = UIAlertAction(title: "从相册选择", style: UIAlertActionStyle.default, handler: funcChooseFromPhotoAlbum)
        userIconAlert.addAction(chooseFromPhotoAlbum)
        
        let chooseFromCamera = UIAlertAction(title: "拍照", style: UIAlertActionStyle.default,handler:funcChooseFromCamera)
        userIconAlert.addAction(chooseFromCamera)
        
        let canelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler: nil)
        userIconAlert.addAction(canelAction)
        
        self.present(userIconAlert, animated: true, completion: nil)
    }
    
    //从相册选择照片
    func funcChooseFromPhotoAlbum(avc:UIAlertAction) -> Void{
        let imagePicker = UIImagePickerController()
        //设置代理
        imagePicker.delegate = self
        //允许编辑
        imagePicker.allowsEditing = true
        //设置图片源
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //模态弹出IamgePickerView
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //拍摄照片
    func funcChooseFromCamera(avc:UIAlertAction) -> Void{
        let imagePicker = UIImagePickerController()
        //设置代理
        imagePicker.delegate = self
        //允许编辑
        imagePicker.allowsEditing=true
        //设置图片源
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        //模态弹出IamgePickerView
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //UIImagePicker回调方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //获取照片的原图
        //let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
        //获得编辑后的图片
        let image = (info as NSDictionary).object(forKey: UIImagePickerControllerEditedImage)
        
        //保存图片至沙盒
        self.saveImage(currentImage: image as! UIImage, imageName: "iconImageFileName")
        let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("iconImageFileName")
        
        //存储后拿出更新头像
        let savedImage = UIImage(contentsOfFile: fullPath)
        let index = IndexPath(row:0, section: 1)
        let cell = tableView.cellForRow(at:index) as! studioAvatorTableViewCell
        cell.avator.image = savedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - 保存图片至沙盒
    func saveImage(currentImage:UIImage,imageName:String){
        var imageData = NSData()
        imageData = UIImageJPEGRepresentation(currentImage, 0.5)! as NSData
        // 获取沙盒目录
        let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(imageName)
        // 将图片写入文件
        imageData.write(toFile: fullPath, atomically: false)
    }
    
}

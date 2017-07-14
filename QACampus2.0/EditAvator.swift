//
//  editAvator.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/30.
//  Copyright © 2017年 Demons. All rights reserved.
//

import Foundation
import UIKit

//编辑工作室头像
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
        imagePicker.allowsEditing = true
        //设置图片源
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        //模态弹出IamgePickerView
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //UIImagePicker回调方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.saveImage(currentImage: image, imageName: "iconImageFileName")
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.saveImage(currentImage: image, imageName: "iconImageFileName")
        } else {
            print("something wet wrong")
        }
        print(info)
        
        //保存图片至沙盒
//        self.saveImage(currentImage: image, imageName: "iconImageFileName")
        let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("iconImageFileName")
        
        //存储后拿出更新头像
        avator = UIImage(contentsOfFile: fullPath)
        prepareForStorage(fullPath, destination: "https://localhost:6666/1/")
        picker.dismiss(animated: true, completion: nil)
        tableView.reloadData()
        
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


extension PersonalEditTableViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
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
        imagePicker.allowsEditing = true
        //设置图片源
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        //模态弹出IamgePickerView
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //UIImagePicker回调方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.saveImage(currentImage: image, imageName: "personalAvator")
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.saveImage(currentImage: image, imageName: "personalAvator")
        } else {
            print("something wet wrong")
        }
        
        let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent("personalAvator")
        
        //存储后拿出更新头像
        avator = UIImage(contentsOfFile: fullPath)!
        //准备上传头像
        prepareForStorage(fullPath, destination: "https://localhost:6666/1/")
        picker.dismiss(animated: true, completion: nil)
        tableView.reloadData()
        
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


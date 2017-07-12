//
//  alertView.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SnapKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class alertView: UIView {

    //1 声明变量
    var myImageView = UIImageView()
    var content = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //2 初始化视图
        self.backgroundColor = .black
        self.alpha = 0.75
        self.layer.cornerRadius = 10.0
        
        self.addSubview(content)
        content.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.2)
            make.height.equalToSuperview().dividedBy(2)
            make.top.equalToSuperview().offset(10)
        })
        content.textColor = .white
        content.numberOfLines = 2
        content.font = UIFont(name:"System",size:24.0)
        content.textAlignment = .center
        
        self.addSubview(myImageView)
        myImageView.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40.0)
            make.bottom.equalToSuperview().offset(-30.0)
        
        })
        
        
    }
    
    //3 增加设置图片方法
    func addImage(image: UIImage) {
        myImageView.image = image
    }
    
    func addContent(content:String) {
        self.content.text = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

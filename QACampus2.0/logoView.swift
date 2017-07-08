//
//  logoView.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class logoView: UIView {

    let returnBtn = UIButton()//返回个人信息界面按钮
    let logoImage = UIImageView()//设置logo
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup(){
        self.addSubview(logoImage)
        logoImage.image = UIImage(named:"no.2")
        
        logoImage.snp.makeConstraints{ make in
            make.height.width.equalToSuperview().dividedBy(2.5)
            make.center.equalToSuperview()
        }
        
        self.addSubview(returnBtn)
        returnBtn.snp.makeConstraints{ make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-10)
        }
        returnBtn.setImage(#imageLiteral(resourceName: "back"), for:.normal)
        returnBtn.setTitleColor(.red, for: .normal)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

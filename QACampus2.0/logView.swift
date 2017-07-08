//
//  logView.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class logView: UIView {

    let infoView = UIView()//信息框
    let devideLine = UIView()//分割线
    var inputField = [UITextField]()//输入框集合
    var line = [UIView]()//分割线集合
    var fieldNum = 0 //输入框的数量
    public let logBtn = UIButton()//登录按钮
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup(){
        self.addSubview(infoView)
        self.addSubview(logBtn)
        infoView.backgroundColor = .white
        infoView.layer.borderColor = UIColor(red:220/255,green:220/255,blue:220/255,alpha:1).cgColor
        infoView.layer.borderWidth = 1.0
        infoView.layer.cornerRadius = 8.0
        
        infoView.snp.makeConstraints{ make in
            make.height.equalToSuperview().dividedBy(3.5-0.5*Double(fieldNum))
            make.width.equalToSuperview().dividedBy(1.2)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        for i in 0..<fieldNum {
            inputField.append(UITextField())
            infoView.addSubview(inputField[i])
            if i == 0{
                inputField[i].snp.makeConstraints{ make in
                    make.top.centerX.equalToSuperview()
                    make.height.equalToSuperview().dividedBy(Double(fieldNum)+0.1)
                    make.width.equalToSuperview().dividedBy(1.2)
                }
            }
            else {
                line.append(UIView())
                infoView.addSubview(line[i-1])
                line[i-1].backgroundColor = shadowColor
                line[i-1].snp.makeConstraints{ make in
                    make.height.equalTo(2)
                    make.top.equalTo(inputField[i-1].snp.bottom)
                    make.width.centerX.equalToSuperview()
                }
                inputField[i].snp.makeConstraints{ make in
                    make.top.equalTo(line[i-1].snp.bottom)
                    make.centerX.equalToSuperview()
                    make.height.equalToSuperview().dividedBy(Double(fieldNum)+0.1)
                    make.width.equalToSuperview().dividedBy(1.2)
                }
            }
        }

        logBtn.backgroundColor = UIColor(red:250/255,green:235/255,blue:235/255,alpha:1)
        logBtn.layer.borderColor = UIColor(red:220/255,green:220/255,blue:220/255,alpha:1).cgColor
        logBtn.layer.borderWidth = 1.0
        logBtn.layer.cornerRadius = 8.0
        logBtn.snp.makeConstraints{ make in
            make.height.equalToSuperview().dividedBy(6)
            make.top.equalTo(infoView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.2)
        }
    }
    
    func setFieldNum(num: Int){
        fieldNum = num
        setup()
    }
    
    func getEmail() -> String {
        return inputField[0].text!
    }
    
    func getPassword() -> String {
        return inputField[1].text!
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

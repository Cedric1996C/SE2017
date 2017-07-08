//
//  bottomChoicesView.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class bottomChoicesView: UIView {

    let divideLine = UIView()
    var choices = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        self.addSubview(divideLine)
        choices.append(UIButton())
        choices.append(UIButton())
        choices[0].setTitle("新用户注册", for: .normal)
        choices[0].titleLabel?.textAlignment = NSTextAlignment.right
        choices[1].setTitle("随便看看", for: .normal)
        choices[1].titleLabel?.textAlignment = NSTextAlignment.left
        divideLine.backgroundColor = shadowColor
        
        for i in 0...1 {
            choices[i].titleLabel?.font = UIFont.systemFont(ofSize: 14)
            choices[i].setTitleColor(grey,for: .normal)
            
            self.addSubview(choices[i])
            choices[i].snp.makeConstraints{ make in
                make.width.equalToSuperview().dividedBy(4.1)
                make.height.top.equalToSuperview()
                if i == 0{
                    make.centerX.equalToSuperview().offset(-45)
                }
                else {
                    make.centerX.equalToSuperview().offset(45)
                }
            }
        }
        divideLine.snp.makeConstraints{ make in
            make.height.equalToSuperview().dividedBy(2)
            make.center.equalToSuperview()
            make.width.equalTo(2)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

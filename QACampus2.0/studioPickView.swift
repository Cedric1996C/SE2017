//
//  studioPickView.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/17.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class studioPickView: UIPickerView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension studioPickView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return User.studios_name[User.studios[row]]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return User.studio_num
    }
}

extension studioPickView: UIPickerViewDelegate {
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let width = self.view.frame.width
//        let height = self.view.frame.height
//        let userVc =  UIStoryboard.init(name: "StudioTab", bundle: nil).instantiateInitialViewController()
//        userVc!.view.frame = CGRect(x:0, y:0,width: width, height:height)
//        self.present(userVc!, animated: true, completion: nil)
//        
//    }
}


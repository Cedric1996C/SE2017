//
//  ContainerViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/18.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {

    
    override func awakeFromNib() {
        if let mainVc = UIStoryboard(name:"MainInterface",bundle:nil).instantiateInitialViewController(){
            self.mainViewController = mainVc
        }
        if let rightVc = UIStoryboard(name:"PickStudio",bundle:nil).instantiateInitialViewController(){
            self.rightViewController = rightVc
        }
        super.awakeFromNib()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  topicDetailViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/14.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class topicDetailViewController: UIViewController {
    @IBOutlet weak var bottomView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let _width = self.view.frame.width
        let _height = self.view.frame.height - CGFloat(50.0)
        let detailVc =  UIStoryboard.init(name: "TopicDetail", bundle: nil).instantiateViewController(withIdentifier: "TopicDetail")
        detailVc.view.frame = CGRect(x:0, y:0,width: _width, height:_height)
        self.view.addSubview(detailVc.view)
        detailVc.view.layer.zPosition = 99
        bottomView.layer.zPosition = 100
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

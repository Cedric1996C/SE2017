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
    //var studioId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.studioId=LocalStudio.id
        let _width = self.view.frame.width
        let _height = self.view.frame.height - CGFloat(50.0)
        let detailVc =  UIStoryboard.init(name: "TopicDetail", bundle: nil).instantiateViewController(withIdentifier: "TopicDetail")
        //let detailVc = UIStoryboard.init(name: "TopicDetail", bundle: nil)
        detailVc.view.frame = CGRect(x:0, y:0,width: _width, height:_height)
        self.view.addSubview(detailVc.view)
        self.view.backgroundColor  = .red
        detailVc.view.layer.zPosition = 99
        bottomView.layer.zPosition = 100
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}

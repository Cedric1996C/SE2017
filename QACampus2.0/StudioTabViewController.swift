//
//  StudioTabViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/26.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class StudioTabViewController: UIViewController {

    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var homeIcon: UIButton!
    @IBOutlet weak var homeLabel: UILabel!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var addIcon: UIButton!
   
    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionIcon: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    var homeVc: UIViewController?
    var addVc:UIViewController?
    var questionVc:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeIcon.isSelected = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        layoutUI()
    }
    
    func layoutUI() {
        let _width = self.view.frame.width
        let _height = self.view.frame.height - CGFloat(50.0)
//        let _height = self.view.frame.height
        
        //注册controller
        homeVc = UIStoryboard.init(name: "StudioHome", bundle: nil).instantiateInitialViewController()
        homeVc!.view.frame = CGRect(x:0, y:0,width: _width, height:_height)
        self.addChildViewController(homeVc!)
        
        questionVc = UIStoryboard.init(name: "StudioQuestion", bundle: nil).instantiateInitialViewController()
        questionVc!.view.frame = CGRect(x:0, y:0,width: _width, height:_height)
        self.addChildViewController(questionVc!)
        
        //设置初始的Controller
        self.view.addSubview(homeVc!.view)
        
        //设置样式
        homeView.backgroundColor = sectionHeaderColor
        addView.backgroundColor = sectionHeaderColor
        questionView.backgroundColor = sectionHeaderColor
    }
    
    func replaceController(newController: UIViewController) {
        //判断即将显示的controller是否已经压入栈
        if (newController.view.isDescendant(of: self.view)) {
            //将该controller放到容器最上面显示出来
            self.view.bringSubview(toFront: newController.view);
        }
        else{
            self.view.addSubview(newController.view)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    @IBAction func switchHome(_ sender: Any) {
        replaceController(newController: homeVc!)
    }

    
    @IBAction func switchQuestion(_ sender: Any) {
        replaceController(newController: questionVc!)
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

//
//  studioTarBarViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/26.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class studioTarBarViewController: UITabBarController {

    @IBOutlet weak var bar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
//        initItem()
        // Do any additional setup after loading the view.
    }
    
    func initButton() {
        let pushTopicEdit = UIButton()
        pushTopicEdit.setImage(UIImage(named:"add01"),for: .normal)
       
        pushTopicEdit.addTarget(self, action: #selector(add), for: UIControlEvents.touchUpInside)
        
//                pushTopicEdit.tintColor = defaultColor
        
        bar.addSubview(pushTopicEdit)
        
        pushTopicEdit.snp.makeConstraints{ make in
            make.width.height.equalTo(30)
            make.center.equalToSuperview()
        }
    

    }

    func initItem(){
        let studioHome = studioHomeViewController()
        studioHome.title = "studioHome"
        let studioQuestion = studioHomeQuestionViewController()
        studioHome.title = "studioQuestion"
        
        let home = UINavigationController(rootViewController:studioHome)
        home.tabBarItem.image = UIImage(named:"home01")
        let question = UINavigationController(rootViewController:studioQuestion)
        question.tabBarItem.image = UIImage(named:"question01")
        self.viewControllers = [home,question]
        
        // 默认选中的是qq视图
        self.selectedIndex = 0
        self.tabBar.tintColor = defaultColor
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

extension studioTarBarViewController {
    
    func add (sender:Any) {
        performSegue(withIdentifier: "pushTopicEdit", sender:self)
    }
}

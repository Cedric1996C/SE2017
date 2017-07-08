//
//  studioTopicViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/25.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class studioTopicEditViewController: UIViewController {

    @IBOutlet weak var titleView: UITextField!
    @IBOutlet weak var divideView: UIView!
    @IBOutlet weak var detailView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divideView.backgroundColor = sectionHeaderColor
        self.tabBarController?.tabBar.isHidden = true
        initButton()
        // Do any additional setup after loading the view.
    }
    
    func initButton(){
        
        let cancelBtn = UIButton()
        cancelBtn.setImage(UIImage(named:"close01"),for: .normal)
//        cancelBtn.setImage(UIImage(named:"close02"), for: .selected)
        cancelBtn.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
        
        let saveBtn=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.plain, target: self, action: #selector(save))
        self.navigationItem.rightBarButtonItem = saveBtn
        
        saveBtn.tintColor = defaultColor
        cancelBtn.tintColor = defaultColor
        
        self.navigationController?.navigationBar.addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints{ make in
            make.width.height.equalTo(18)
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(12)
        }
        
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

extension studioTopicEditViewController {
    
    func cancel(sender:Any){
        self.dismiss(animated: true, completion: nil)
//        self.tabBarController?.performSegue(withIdentifier: "pushHome", sender: self)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    //Ajax请求 保存相应的信息，并返回
    func save(sender:Any) {
        /*
         
         */
        self.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }

}

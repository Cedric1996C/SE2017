//
//  pickStudioViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/17.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class pickStudioViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,SlideMenuControllerDelegate {

    @IBOutlet weak var avator: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var questionNum: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        avator.contentMode = .scaleAspectFill
        avator.layer.masksToBounds = true
        avator.layer.cornerRadius = avator.frame.width/2
        initData()
        
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    func rightWillOpen() {
        initData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(User.studios)
        return User.studios.count        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studioVc = UIStoryboard.init(name: "StudioTab", bundle: nil).instantiateInitialViewController()
        self.present(studioVc!, animated: true, completion: nil)
        LocalStudio.id = (User.studios[indexPath.row] != nil) ? User.studios[indexPath.row] : 1
        self.slideMenuController()?.closeRight()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickStudio", for: indexPath) as! pickStudioTableViewCell
        cell.name.text = User.studios_name[User.studios[indexPath.row]]
        print(cell.name.text)
//        cell.name.text = "123123123123123123"
        return cell
        
    }
    
    
    func initData(){
        name.text = User.name
        avator.image = (User.avator != nil) ? User.avator : UIImage(named:"no.1")
        questionNum.text = "进入\(User.studio_num!)个工作室，回答了\(User.question_num!)个问题"
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

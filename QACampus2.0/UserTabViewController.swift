//
//  UserTabViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/27.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height


class UserTabViewController: UIViewController {

    
    @IBOutlet weak var hotView: UIView!
    @IBOutlet weak var hotIcon: UIButton!
    @IBOutlet weak var hotLabel: UILabel!
    
    @IBOutlet weak var studioView: UIView!
    @IBOutlet weak var studioIcon: UIButton!
    @IBOutlet weak var studioLabel: UILabel!
    
    //此处的命名与父层次user重复，但事先绑定，暂时没有修改，请注意一下。后续用userInfo来代指这一个界面
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userIcon: UIButton!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationIcon: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    
    var hotVc:UIViewController?
    var studioVc:UIViewController?
    var infoVc:UIViewController?
    var notificationVc:UIViewController?
    
    override func viewDidAppear(_ animated: Bool) {
        localUserCheck()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authentication()
       
        initUI()
        initUserInfo()
        initControllers()
        
        view.backgroundColor = sectionHeaderColor
        hotIcon.isSelected = true
        // Do any additional setup after loading the view.
    }

    func initUserInfo(){
        
        let userDefault = UserDefaults.standard
        //自定义对象读取
        if let user = userDefault.data(forKey: "local_user") {
            let localUser = NSKeyedUnarchiver.unarchiveObject(with: user) as! User
            User.localUserId = localUser.userId!
            User.localEmail = localUser.email!
            
            let path = "/user/\(localUser.userId!)"
            let headers:HTTPHeaders = [
                "Authorization":userAuthorization
            ]
            
            //请求用户的信息
            Alamofire.request("https://\(root):8443/owner-service/owners/\(User.localUserId!)", method: .get,headers: headers).responseJSON { response in
                
                if  response.result.value != nil {
                    if (response.response?.statusCode)! == 200 {
                        let userJSON = JSON(response.result.value!)
                        print(userJSON)
                        User.question_num = userJSON["question_num"].int
                        User.answer_num = userJSON["answer_num"].int
                        User.studio_num = userJSON["studio_num"].int
                        var temp: JSON = userJSON["question"]
                        User.myQuestion = temp.array?.count
                        temp = userJSON["_question_collect"]
                        User.collectQuestion = temp.array?.count
                        temp = userJSON["_studio_collect"]
                        User.collectStudio = temp.array?.count
                        temp = userJSON["_topic_collect"]
                        User.collectTopic = temp.array?.count
                        User.name = userJSON["display_name"].string
                        User.introduction = userJSON["introduction"].string
                    }
                }
                
            }

        }
    }
    
    func initControllers() {
        let width = self.view.frame.width
        let height = self.view.frame.height - CGFloat(57.0)
        
        //注册controller
        hotVc = UIStoryboard.init(name: "UserHot", bundle: nil).instantiateInitialViewController()
        hotVc!.view.frame = CGRect(x:0, y:0,width: width, height:height)
        self.addChildViewController(hotVc!)
        
        studioVc = UIStoryboard.init(name: "UserStudio", bundle: nil).instantiateInitialViewController()
        studioVc!.view.frame = CGRect(x:0, y:0,width: width, height:height)
        self.addChildViewController(studioVc!)
        
        infoVc = UIStoryboard.init(name: "PersonalInfo", bundle: nil).instantiateInitialViewController()
        infoVc!.view.frame = CGRect(x:0, y:0,width: width, height:height)
        self.addChildViewController(infoVc!)
        
        notificationVc = UIStoryboard.init(name: "UserNotification", bundle: nil).instantiateInitialViewController()
        notificationVc!.view.frame = CGRect(x:0, y:0,width: width, height:height)
        self.addChildViewController(notificationVc!)
        
        //设置初始的Controller
        self.view.addSubview(hotVc!.view)
        
        //设置样式
        hotView.backgroundColor = sectionHeaderColor
        studioView.backgroundColor = sectionHeaderColor
        userView.backgroundColor = sectionHeaderColor
        notificationView.backgroundColor = sectionHeaderColor

    }
    
    func initUI () {
        var views = [UIView]()
        views.append(hotView)
        views.append(studioView)
        views.append(userView)
        views.append(notificationView)
        
        for i in 0..<views.count {
//            views[i].frame.width = self.view.frame.width / 4
            views[i].snp.makeConstraints{ make in
                make.width.equalToSuperview().dividedBy(4)
                make.centerY.equalToSuperview()
                if i == 0{
                    make.left.equalToSuperview()
                }
                else {
                    make.left.equalTo(views[i-1].snp.right)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchHot(_ sender: Any) {
        replaceController(newController: hotVc!)
    }

    @IBAction func switchStudio(_ sender: Any) {
        replaceController(newController: studioVc!)
    }
    
    @IBAction func switchUser(_ sender: Any) {
        replaceController(newController: infoVc!)
    }
    
    @IBAction func switchNotification(_ sender: Any) {
        replaceController(newController: notificationVc!)
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

extension UserTabViewController {
    
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

    //检测本地是否有账户数据
    func localUserCheck() {
        let userDefault = UserDefaults.standard
        
        //自定义对象读取
        let local_user = userDefault.data(forKey: "local_user")
        
        if(local_user == nil){
            let mainVC = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            self.present(mainVC!, animated: true, completion: nil)
        } else {
            initUserInfo()
//            let user = NSKeyedUnarchiver.unarchiveObject(with: local_user!) as! User
        }
        
    }

    
}

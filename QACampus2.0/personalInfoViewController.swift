//
//  personalInfoViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/5/8.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import AlamofireObjectMapper

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

class personalInfoViewController: UIViewController {

    let devideLine1 = UIView()
    let personalIntro = UIView()//存放个人信息简介的盒子

    let avatar_image = UIImageView()//头像图片
    let personalId = UILabel()//用户名称
    let introduce  = UILabel()//用户简介
    let QAnum = UILabel()//问了xx个问题，获得xx个赞
    let Qlabel = UILabel()
    let Alabel = UILabel()
    var Qnum:Int = 3
    var Anum:Int = 5
    let alterBtn = UIButton()//编辑按钮

    // MARK:- 懒加载属性
    /// 子标题
    lazy var btnNames:[String] = {
        return ["问题","话题","工作室"]
    }()
    
    /// 子控制器
    lazy var controllers: [UIViewController] = { [unowned self] in
        var cons: [UIViewController] = [UIViewController]()
        for title in self.btnNames {
            let con = personalSubFactory.personalSubWith(identifier: title)
            cons.append(con)
        }
        return cons
    }()
    
    /// 子标题视图
    lazy var subTitleView: personalSubTitleView = { [unowned self] in
        let view = personalSubTitleView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
//        view.addSubview(view)
        return view
    }()

    /// 控制多个子控制器
    lazy var PageVc: pageViewController = {
        let pageVc = pageViewController(superController: self, controllers: self.controllers)
        pageVc.delegate = self as? PageViewControllerDelegate
        pageVc.view.backgroundColor = .red
        return pageVc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        initLayout()
        initScrollView()
        initPersonalIntro()
    }

    func initNavigation(){        
        let logBtn: UIButton = UIButton()//登录按钮，设置在导航栏的右侧

        //设置导航栏底色透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.addSubview(logBtn)
        logBtn.snp.makeConstraints{ make in
            make.height.width.equalTo(30)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        logBtn.setTitle("log", for: .normal)
        logBtn.addTarget(self, action: #selector(logClick), for:UIControlEvents.touchUpInside)
    }
    
    func initLayout(){
        
        personalIntro.backgroundColor = UIColor(red:250/255,green:235/255,blue:235/255,alpha:1)
        devideLine1.backgroundColor = UIColor(red:235/255,green:235/255,blue:235/255,alpha:1)

        view.addSubview(personalIntro)
        view.addSubview(devideLine1)
        view.addSubview(subTitleView)
        view.addSubview(PageVc.view)
     
        personalIntro.snp.makeConstraints{ make in
            make.height.equalTo(240)
            make.top.right.left.equalToSuperview()
        }
        
        devideLine1.snp.makeConstraints{ make in
            make.height.equalTo(2)
            make.top.equalTo(personalIntro.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        subTitleView.snp.makeConstraints{ make in
            make.top.equalTo(devideLine1.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(40)
        }
        
        PageVc.view.snp.makeConstraints { make in
            make.top.equalTo(subTitleView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    
    func initScrollView(){
        subTitleView.delegate = self as? personalSubTitleViewDelegate
        subTitleView.titleArray = btnNames
    }
     //初始化个人简介
    func initPersonalIntro(){
        personalId.text = "南大鸽子王"
        introduce.text = "逢约必鸽，不见不散"
        QAnum.text = "提出了    个问题，获得了    个喜欢"
        QAnum.textAlignment = .center
        alterBtn.setTitle("点击编辑个人资料", for: .normal)
        alterBtn.setTitleColor(UIColor.black, for: .normal)
        introduce.font =  UIFont.systemFont(ofSize: 10)
        QAnum.font =  UIFont.systemFont(ofSize: 10)
        alterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        alterBtn.layer.borderColor = UIColor(red:255/255,green:235/255,blue:235/255,alpha:1).cgColor
        alterBtn.layer.borderWidth = 1.0
        alterBtn.layer.cornerRadius = 4.0

        let infoContanier = UIView()//存放信息的子容器
        personalIntro.addSubview(infoContanier)
        
        infoContanier.backgroundColor = UIColor.white
        infoContanier.snp.makeConstraints{ make in
            make.width.equalToSuperview().dividedBy(2)
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.equalToSuperview()
            make.center.equalToSuperview()
        }
        infoContanier.addSubview(avatar_image)
        avatar_image.image = UIImage(named:"no.1")
        avatar_image.snp.makeConstraints{ make in
            make.width.height.equalTo(80)
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(-40)
            make.centerX.equalToSuperview()
        }
        
        infoContanier.addSubview(personalId)
        infoContanier.addSubview(introduce)
        infoContanier.addSubview(QAnum)
        infoContanier.addSubview(alterBtn)
        
        personalId.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        introduce.snp.makeConstraints{ make in
            make.top.equalTo(personalId.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        QAnum.snp.makeConstraints{ make in
            make.top.equalTo(introduce.snp.bottom)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(20)
        }
        QAnum.addSubview(Qlabel)
        QAnum.addSubview(Alabel)
        for i in 0...1 {
            QAnum.subviews[i].snp.makeConstraints{ make in
                make.height.centerY.equalToSuperview()
                make.width.equalToSuperview().dividedBy(19)
                if i == 0{
                    make.centerX.equalToSuperview().offset(-42)
                }
                else{
                    make.centerX.equalToSuperview().offset(42)
                }
            }
        }
        Qlabel.text = String(self.Qnum)
        Alabel.text = String(self.Anum)
        
        alterBtn.snp.makeConstraints{ make in
            make.top.equalTo(QAnum.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(120)
        }

        alterBtn.addTarget(self, action:#selector(alterClick), for:UIControlEvents.touchUpInside)
        
    }
    //点击事件
    func alterClick(sender:UIButton){
        Alamofire.request("http://localhost:8080/api/city?cityName=%E6%B8%A9%E5%B2%AD%E5%B8%82").responseObject {(response: DataResponse<userResponse>) in
            //let json = response.result.value
        }
    }
    
    func logClick(sender:UIButton){
        //实例化一个登陆界面
        let loginView = loginViewController()
        //从下弹出一个界面作为登陆界面，completion作为闭包，可以写一些弹出loginView时的一些操作
        self.present(loginView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - pageViewController代理
extension personalInfoViewController: PageViewControllerDelegate{
    func PageCurrentSubControllerIndex(index: NSInteger, pageViewController: pageViewController) {
        subTitleView.jump2Show(at: index)
    }
}

// MARK:- personalSubTitleViewDelegate
extension personalInfoViewController: personalSubTitleViewDelegate {
    func personalSubTitleViewDidSelected(_ titleView: personalSubTitleView, atIndex: NSInteger, title: String) {
        // 跳转对相应的子标题界面
        PageVc.setCurrentSubControllerWith(index: atIndex)
    }
}



//
//  studioInfoViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/23.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class studioInfoViewController: UIViewController {

    
    @IBOutlet weak var subPageView: UIView!
//    @IBOutlet weak var studioAvator: UIImageView!
    @IBOutlet weak var collectIcon: UIImageView!
    @IBOutlet weak var collectLabel: UILabel!
    
    @IBOutlet weak var studioName: UILabel!
    @IBOutlet weak var introduction: UILabel!
    
    // MARK:- 懒加载属性
    /// 子标题
    lazy var btnNames:[String] = {
        return ["最新回答","最新话题","热门","成员"]
    }()
    
    /// 子控制器
    lazy var controllers: [UIViewController] = { [unowned self] in
        var cons: [UIViewController] = [UIViewController]()
        for title in self.btnNames {
            let con = studioInfoSubFactory.studioInfoSubWith(identifier: title)
            cons.append(con)
        }
        return cons
        }()
    
    /// 子标题视图
    lazy var subTitleView: studioInfoSubTitleView = { [unowned self] in
        let view = studioInfoSubTitleView(frame: CGRect(x: 0, y: 1, width: ScreenWidth, height: 39))
        //        view.addSubview(view)
        return view
        }()
    
    /// 控制多个子控制器
    lazy var PageVc: pageViewController = {
        let pageVc = pageViewController(superController: self, controllers: self.controllers)
        pageVc.delegate = self as? PageViewControllerDelegate
        return pageVc
    }()
    
    lazy var studioAvator: UIImageView = { [unowned self] in
        let avator = UIImageView()
        return avator
    }()

    lazy var isCollected: Bool = {
        return false
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageVc()
        initInfo()
        initButton()
        initAvator()

        // self.navigationController?.navigationBar.addSubview(studioAvator)
        // Do any additional setup after loading the view.
    }
    
    func initButton(){
        let item=UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(returnUser))
        item.tintColor = defaultColor
        self.navigationItem.leftBarButtonItem = item
    }
    
    func initInfo () {
        studioName.text = SingletonStudio.title
        studioAvator.image = SingletonStudio.avator
        introduction.text = SingletonStudio.introduction
    }

    func initPageVc(){
        subPageView.addSubview(subTitleView)
        subPageView.addSubview(PageVc.view)
        
        subTitleView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(1.0)
            make.right.left.equalToSuperview()
            make.height.equalTo(39)
        }
        
        PageVc.view.snp.makeConstraints { make in
            make.top.equalTo(subTitleView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        subTitleView.delegate = self as? studioInfoSubTitleViewDelegate
        subTitleView.titleArray = btnNames
        
    }
    
    func initAvator () {
        self.navigationController?.navigationBar.addSubview(studioAvator)
        studioAvator.frame = CGRect(x:SCREEN_WIDTH/2-40,y:5.0,width:80.0,height:80.0)
        studioAvator.contentMode = .scaleAspectFill
        studioAvator.layer.masksToBounds = true
        studioAvator.layer.cornerRadius = studioAvator.frame.width/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func returnUser(sender:Any){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func collectViewTap(_ sender: Any) {
        isCollected = !isCollected
        if isCollected {
            collectIcon.image = UIImage(named:"favorite02")
            collectLabel.text = "已收藏"
            collectLabel.textColor = subTitleBorderColor
        } else {
            collectIcon.image = UIImage(named:"favorite01")
            collectLabel.text = "收藏"
            collectLabel.textColor = iconColor
        }
    }
    
    @IBAction func askViewTap(_ sender: Any) {
        
    }
   
}

// MARK: - pageViewController代理
extension studioInfoViewController: PageViewControllerDelegate{
    func PageCurrentSubControllerIndex(index: NSInteger, pageViewController: pageViewController) {
        subTitleView.jump2Show(at: index)
    }
}

// MARK:- studioInfoSubTitleViewDelegate
extension studioInfoViewController: studioInfoSubTitleViewDelegate {
    func studioInfoSubTitleViewDidSelected(_ titleView: studioInfoSubTitleView, atIndex: NSInteger, title: String) {
        // 跳转对相应的子标题界面
        PageVc.setCurrentSubControllerWith(index: atIndex)
    }
}


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
        let view = studioInfoSubTitleView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
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
        let image = UIImageView()
        image.image = UIImage(named:"no.1")
        return image
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageVc()
        initButton()
        self.navigationController?.navigationBar.addSubview(studioAvator)
        studioAvator.snp.makeConstraints ({ make in
            make.height.width.equalTo(80)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        })

        // self.navigationController?.navigationBar.addSubview(studioAvator)
        // Do any additional setup after loading the view.
    }
    
    func initButton(){
        let item=UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(returnUser))
        item.tintColor = defaultColor
        self.navigationItem.leftBarButtonItem = item
    }

    func initPageVc(){
        subPageView.addSubview(subTitleView)
        subPageView.addSubview(PageVc.view)
        
        subTitleView.snp.makeConstraints{ make in
//            make.top.equalTo(devideLine1.snp.bottom)
            make.top.right.left.equalToSuperview()
            make.height.equalTo(40)
        }
        
        PageVc.view.snp.makeConstraints { make in
            make.top.equalTo(subTitleView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        subTitleView.delegate = self as? studioInfoSubTitleViewDelegate
        subTitleView.titleArray = btnNames
        
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
    
    func returnUser(sender:Any){
        self.dismiss(animated: true, completion: nil)
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


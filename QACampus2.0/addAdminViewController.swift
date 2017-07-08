//
//  addAdminViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/30.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class addAdminViewController: UIViewController {
    
    @IBOutlet weak var subPageView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    //    @IBOutlet weak var studioAvator: UIImageView!
    
    // MARK:- 懒加载属性
    /// 子标题
    lazy var btnNames:[String] = {
        return ["全部","关注"]
    }()
    
    /// 子控制器
    lazy var controllers: [UIViewController] = { [unowned self] in
        var cons: [UIViewController] = [UIViewController]()
        for title in self.btnNames {
            let con = addAdminButtons.addAdminSubWith(identifier: title)
            cons.append(con)
        }
        return cons
        }()
    
    /// 子标题视图
    lazy var subTitleView: addAdminButtonView = { [unowned self] in
        let view = addAdminButtonView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
        //        view.addSubview(view)
        return view
        }()
    
    /// 控制多个子控制器
    lazy var PageVc: pageViewController = {
        let pageVc = pageViewController(superController: self, controllers: self.controllers)
        pageVc.delegate = self as? PageViewControllerDelegate
        return pageVc
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPageVc()
        searchBar.tintColor = defaultColor
        searchBar.delegate = self
        searchBar.placeholder = "请输入用户的昵称"
        searchBar.text = ""
        searchBar.isSearchResultsButtonSelected = true
        
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
        
        subTitleView.delegate = self as? addAdminButtonViewDelegate
        subTitleView.titleArray = btnNames
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Return to superVc
    func returnHome(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - pageViewController代理
extension addAdminViewController: PageViewControllerDelegate{
    func PageCurrentSubControllerIndex(index: NSInteger, pageViewController: pageViewController) {
        subTitleView.jump2Show(at: index)
    }
}

// MARK:- addAdminButtonViewDelegate
extension addAdminViewController: addAdminButtonViewDelegate {
    func addAdminButtonViewDidSelected(_ titleView: addAdminButtonView, atIndex: NSInteger, title: String) {
        // 跳转对相应的子标题界面
        PageVc.setCurrentSubControllerWith(index: atIndex)
    }
}

// MARK:-UISearchBarDelegate
extension addAdminViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

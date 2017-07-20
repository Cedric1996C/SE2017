
//
//  studioHomeViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/24.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class studioHomeViewController: UIViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var studioName: UILabel!
    @IBOutlet weak var studioIntro: UILabel!
    @IBOutlet weak var QustionAndTopic: UILabel!
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var editViewIcon: UIImageView!
    @IBOutlet weak var editViewLabel: UILabel!
    
    @IBOutlet weak var pageView: UIView!
    
    // MARK:- 懒加载属性
    /// 子标题
    lazy var btnNames:[String] = {
        return ["已解决","话题"]
    }()
    
    /// 子控制器
    lazy var controllers: [UIViewController] = { [unowned self] in
        var cons: [UIViewController] = [UIViewController]()
        for title in self.btnNames {
            let con = studioHomeSubFactory.studioHomeSubWith(identifier: title)
            cons.append(con)
        }
        return cons
        }()
    
    /// 子标题视图
    lazy var subTitleView: studioHomeSubTitleView = { [unowned self] in
        let view = studioHomeSubTitleView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
        return view
        }()
    
    /// 控制多个子控制器
    lazy var PageVc: pageViewController = {
        let pageVc = pageViewController(superController: self, controllers: self.controllers)
        pageVc.delegate = self as? PageViewControllerDelegate
//        pageVc.view.backgroundColor = .red
        return pageVc
        }()
    
    lazy var studioAvator: UIImageView = { [unowned self] in
        let image = UIImageView()
        return image
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        authentication()
        let item=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(returnUser))
        item.tintColor = defaultColor
        self.navigationItem.leftBarButtonItem = item

        initData()
        initView()
        initPageView()
        initAvator()
        // Do any additional setup after loading the view.
    }
    
    func initView(){
        editView.layer.borderWidth = CGFloat(1.0)
        editView.layer.borderColor = defaultColor.cgColor
        editView.layer.cornerRadius = 5.0
        editViewLabel.textColor = defaultColor
    }

    func initPageView() {
        pageView.addSubview(subTitleView)
        pageView.addSubview(PageVc.view)
        
        let devideLine = UIView()
        subTitleView.addSubview(devideLine)
        devideLine.backgroundColor = subTitleBorderColor
        
        subTitleView.snp.makeConstraints{ make in
            make.right.top.left.equalToSuperview()
            make.height.equalTo(40)
        }
        
        PageVc.view.snp.makeConstraints { make in
            make.top.equalTo(subTitleView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        subTitleView.delegate = self as? studioHomeSubTitleViewDelegate
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
    
    @IBAction func returnToUser(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        print("finish home")
    }
    
    @IBAction func editStudioInfo(_ sender: UITapGestureRecognizer) {

    }
    
    func returnUser(sender:Any){
        self.dismiss(animated: true, completion: nil)
    }

}

extension studioHomeViewController {
   
    func initData() {
        
        downloadData()
        studioAvator.image = LocalStudio.avator
        studioName.text = LocalStudio.title
        studioIntro.text = LocalStudio.introduction
        QustionAndTopic.text = "解决了\(LocalStudio.answerNUm)个问题，获得了\(LocalStudio.thumbNum)个赞"
    }
    
    func downloadData(){
        
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization
        ]
        
        Alamofire.request("https://\(root):8443/studio-service/studios/\(LocalStudio.id)" ,method: .get, headers: headers).responseJSON { response in
            
            if response.result.value != nil {
                // response serialization result
                var json = JSON(response.result.value!)
                let list: JSON = json["content"].arrayValue[0]
                print(list)
                LocalStudio.introduction = list["introduction"].string!
                let path:String = "studio/\(LocalStudio.id)"
                
                //请求客户端的文件路径下的文件
                Alamofire.request("https://localhost:6666/files/\(path)", method: .get).responseJSON { response in
                    if response.response?.statusCode == 200 {
                        if let json = response.result.value {
                            let pictures:[String] = json as! [String]
                            let pic_path = path.appending("/" + pictures[0])
                            
                            //获取文件
                            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                let fileURL = documentsURL.appendingPathComponent(pic_path)
                                
                                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                            }
                            Alamofire.download("https://localhost:6666/\(pic_path)", to: destination).response { response in
                                
                                if response.error == nil, let imagePath = response.destinationURL?.path {
                                    LocalStudio.avator = getPicture(pic_path)
                                }
                            }
    }}}}}}
}

// MARK: - pageViewController代理
extension studioHomeViewController: PageViewControllerDelegate{
    func PageCurrentSubControllerIndex(index: NSInteger, pageViewController: pageViewController) {
        subTitleView.jump2Show(at: index)
    }
}

// MARK:- studioHomeSubTitleViewDelegate
extension studioHomeViewController: studioHomeSubTitleViewDelegate {
    func studioHomeSubTitleViewDidSelected(_ titleView: studioHomeSubTitleView, atIndex: NSInteger, title: String) {
        // 跳转对相应的子标题界面
        PageVc.setCurrentSubControllerWith(index: atIndex)
    }
}




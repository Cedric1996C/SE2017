//
//  studioInfoViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/23.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire

class studioInfoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var background: UIImageView!
  
    @IBOutlet weak var collectView: UIView!
    @IBOutlet weak var collectIcon: UIImageView!
    @IBOutlet weak var collectLabel: UILabel!
    
    @IBOutlet weak var askView: UIView!
    
    @IBOutlet weak var studioName: UILabel!
    @IBOutlet weak var introduction: UILabel!
    
    @IBOutlet weak var studioAvator: UIImageView!
    
    @IBOutlet weak var infoView: UIView!
    var icons:[UIImage] = []
    var cancelBtn = UIButton()
    
    var type:Int = 0
    // MARK:- 懒加载属性
    /// 子标题
    lazy var icon_titles:[String] = {
        return ["最新回答","最新话题","热门","成员"]
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.clipsToBounds = true
      
        icons.append(UIImage(named:"最新回答")!)
        icons.append(UIImage(named:"最新话题")!)
        icons.append(UIImage(named:"热门")!)
        icons.append(UIImage(named:"成员")!)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        initButton()
        initInfo()
        initAvator()
        
    }
    
    func initButton(){
       
        cancelBtn.setImage(UIImage(named:"back"),for: .normal)
        cancelBtn.setImage(UIImage(named:"cancel02"), for: .selected)
        cancelBtn.tintColor = .white
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        self.navigationController?.navigationBar.addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints{ make in
            make.width.height.equalTo(30)
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(10)
        }
        
        self.view.backgroundColor = pinkColor
        infoView.backgroundColor = pinkColor
        collectView.backgroundColor = pinkColor
        askView.backgroundColor = pinkColor
        collectionView.backgroundColor = pinkColor
        
  }
    
    func initInfo () {
        studioName.text = StudioDetail.title
        studioAvator.image = StudioDetail.avator
        introduction.text = StudioDetail.introduction
        background.image = StudioDetail.background
        isCollected()
    }

    func initAvator () {
        studioAvator.contentMode = .scaleAspectFill
        studioAvator.layer.masksToBounds = true
        studioAvator.layer.cornerRadius = studioAvator.frame.width/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //collectionView Cell个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    //collectionView Cell内容
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identify:String = "StudioInfoClctCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identify,for: indexPath as IndexPath) as! StudioInfoCollectioCell
        cell.label.text = icon_titles[indexPath.row]
        cell.image.image = icons[indexPath.row]
        return cell
        
    }
    //collectionView Cell 跳转
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.type = indexPath.row
        performSegue(withIdentifier: "showStudioInfoList", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="showStudioInfoList"){
            let d = segue.destination as! StudioInfoListController
            d.studioName=self.studioName.text!
            d.studioId = LocalStudio.id
            d.type=self.type
        }
    }
    
    func cancel (sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isCollected () {
        let headers:HTTPHeaders = [
            "Authorization": userAuthorization,
            "studio":  String(LocalStudio.id)
        ]
        if StudioDetail.isCollected {
            collectIcon.image = UIImage(named: "favorite02")
            collectLabel.text = "已收藏"
            collectLabel.textColor = UIColor.lightGray
            
            Alamofire.request("https://\(root):8443/owner-service/owners/\(User.localUserId!)/studio/collect" ,method: .post,headers: headers).responseJSON { response in
            }
            
        } else {
            Alamofire.request("https://\(root):8443/owner-service/owners/\(User.localUserId!)/studio/collect" ,method: .delete,headers: headers).responseJSON { response in
            }
            collectIcon.image = UIImage(named: "favorite01")
            collectLabel.text = "收藏"
            collectLabel.textColor = iconColor
        }
    }

    @IBAction func collectViewTap(_ sender: Any) {
        StudioDetail.isCollected = !StudioDetail.isCollected
        isCollected()
    }
}



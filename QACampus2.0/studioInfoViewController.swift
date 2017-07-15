//
//  studioInfoViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/23.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class studioInfoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var background: UIImageView!
  
    @IBOutlet weak var collectView: UIView!
    @IBOutlet weak var collectIcon: UIImageView!
    @IBOutlet weak var collectLabel: UILabel!
    
    @IBOutlet weak var askView: UIView!
    
    @IBOutlet weak var studioName: UILabel!
    @IBOutlet weak var introduction: UILabel!
    
    @IBOutlet weak var studioAvator: UIImageView!
    
    var icons:[UIImage] = []
    
    var type:Int = 0
    // MARK:- 懒加载属性
    /// 子标题
    lazy var icon_titles:[String] = {
        return ["最新回答","最新话题","热门","成员"]
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.clipsToBounds = true
        // self.navigationController?.navigationBar.addSubview(studioAvator)
        // Do any additional setup after loading the view.
        icons.append(UIImage(named:"answer01")!)
        icons.append(UIImage(named:"comment01")!)
        icons.append(UIImage(named:"hot01")!)
        icons.append(UIImage(named:"user01")!)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        initInfo()
        initAvator()
    }
    
    func initButton(){
        let returnButton = UIButton()
        background.addSubview(returnButton)
        
        background.snp.makeConstraints({ make in
            make.height.width.equalTo(40.0)
//            make.left.top.equalToSuperview().offset(60.0)
            make.center.equalToSuperview()
        })
        
        returnButton.setImage(#imageLiteral(resourceName: "back_pressed"), for: .normal)
        returnButton.setImage(#imageLiteral(resourceName: "back"), for: .highlighted)
        
        returnButton.addTarget(self, action: #selector(cancel), for: UIControlEvents.touchUpInside)
    }
    
    func initInfo () {
        studioName.text = StudioDetail.title
        studioAvator.image = StudioDetail.avator
        introduction.text = StudioDetail.introduction
        background.image = StudioDetail.background
        isCollected()
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
            d.type=self.type
        }
    }
    
    func cancel (sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func isCollected () {
        if StudioDetail.isCollected {
            collectIcon.image = UIImage(named: "favorite02")
            collectLabel.text = "已收藏"
            collectLabel.textColor = UIColor.lightGray
        } else {
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



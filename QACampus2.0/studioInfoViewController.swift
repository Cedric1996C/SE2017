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
    
    @IBOutlet weak var collectView: UIView!
    @IBOutlet weak var collectIcon: UIImageView!
    @IBOutlet weak var collectLabel: UILabel!
    
    @IBOutlet weak var askView: UIView!
    
    @IBOutlet weak var studioName: UILabel!
    @IBOutlet weak var introduction: UILabel!
    
    var icons:[UIImage] = []
    
    var type:Int = 0
    // MARK:- 懒加载属性
    /// 子标题
    lazy var icon_titles:[String] = {
        return ["最新回答","最新话题","热门","成员"]
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
        // self.navigationController?.navigationBar.addSubview(studioAvator)
        // Do any additional setup after loading the view.
        icons.append(UIImage(named:"answer01")!)
        icons.append(UIImage(named:"comment01")!)
        icons.append(UIImage(named:"hot01")!)
        icons.append(UIImage(named:"user01")!)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
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

}



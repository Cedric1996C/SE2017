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
//    @IBOutlet weak var studioAvator: UIImageView!
    
    var icons:[UIImage] = []
    
    var type:Int = 0
    // MARK:- 懒加载属性
    /// 子标题
    lazy var icon_titles:[String] = {
        return ["最新回答","最新话题","热门","成员"]
    }()
    
    
    lazy var studioAvator: UIImageView = { [unowned self] in
        let image = UIImageView()
        image.image = UIImage(named:"no.1")
        return image
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButton()
        self.navigationController?.navigationBar.addSubview(studioAvator)
        studioAvator.snp.makeConstraints ({ make in
            make.height.width.equalTo(80)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        })
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        icons.append(UIImage(named:"answer01")!)
        icons.append(UIImage(named:"comment01")!)
        icons.append(UIImage(named:"hot01")!)
        icons.append(UIImage(named:"user01")!)
        
        // self.navigationController?.navigationBar.addSubview(studioAvator)
        // Do any additional setup after loading the view.
    }
    
    func initButton(){
        let item=UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.plain, target: self, action: #selector(returnUser))
        item.tintColor = defaultColor
        self.navigationItem.leftBarButtonItem = item
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



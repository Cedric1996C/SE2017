//
//  UserNotificationViewController.swift
//  QACampus2.0
//
//  Created by 王乙飞 on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class UserNotificationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    //0:回答 1:评论 2:点赞
    var type:Int = 0
    var infos:[Info]? = []
    
    let icon:UIImage = UIImage(named: "no.1")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initViewDetail()
    }
    
    func initViewDetail() {
        self.tableView.delegate=self
        self.tableView.dataSource=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //返回表格行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4+infos!.count
    }
    //返回单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0){
            return 150.0
        }
        else if(indexPath.row==1){
            return 50.0
        }else {
            return 130.0
        }
    }
    //创建各单元显示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row==0){
            let identify:String = "NotifiClctCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserNotificationCollectionCell
            cell.clctView.delegate=self
            cell.clctView.dataSource=self
            return cell
        }
        else if(indexPath.row==1){
            let identify:String = "NotifiTitleCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserNotificationTitleCell
            cell.titleL.text="通知"
            cell.titleR.text="全部"
            return cell
        }
        else {
            let identify:String = "NotifiListCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserNotificationListCell
//            cell.icon.image=infos?[indexPath.row-2].icon
//            cell.title.text=infos?[indexPath.row-2].title
//            cell.desc.text=infos?[indexPath.row-2].desc
        
            cell.icon.image=icon;
            cell.title.text="新通知"
            cell.desc.text="新通知的描述"
            return cell
        }
    }
    // 点击TableView的一行时调用
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //释放选中效果
        tableView.deselectRow(at: indexPath, animated: true)
        if(indexPath.row==0){
            
        }
        else if(indexPath.row==1){
            
        }
        else {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="showNotifi"){
            let d = segue.destination as! UserNotifiListViewController
            d.type=self.type
            d.navigationItem.title="\(type)"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identify:String = "ClctSubCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identify,for: indexPath as IndexPath) as! CollectionSubCell
        if(indexPath.row==0){
            cell.label.text = "回答"
        }else if(indexPath.row==1){
            cell.label.text = "评论"
        }else if(indexPath.row==2){
            cell.label.text = "点赞"
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.type = indexPath.row
        performSegue(withIdentifier: "showNotifi", sender: (Any).self)
    }

}

//
//  UserNotifiListViewController.swift
//  QACampus2.0
//
//  Created by 王乙飞 on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class UserNotifiListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
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
        if(infos==nil){
            return 1
        }
        return 2+infos!.count
    }
    //返回单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    //创建各单元显示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify:String = "SubListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! SubListCell
        //            cell.icon.image=infos?[indexPath.row-2].icon
        //            cell.title.text=infos?[indexPath.row-2].title
        //            cell.desc.text=infos?[indexPath.row-2].desc
            
        cell.icon.image=icon;
        cell.title.text="新通知\(type)"
        cell.desc.text="新通知的描述"
        return cell
    }
    // 点击TableView的一行时调用
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //释放选中效果
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


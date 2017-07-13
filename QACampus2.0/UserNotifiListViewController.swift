//
//  UserNotifiListViewController.swift
//  QACampus2.0
//
//  Created by 王乙飞 on 2017/7/10.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import Alamofire

class UserNotifiListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //表格底部的空白视图
    var clearFooterView:UIView? = UIView()
    //表格底部用来提示数据加载的视图
    var loadMoreView:UIView?
    //var activityViewIndicator:UIActivityIndicatorView?
    var noMoreRes:UILabel?
    let footer = MJRefreshBackNormalFooter()
    //计数器（用来做延时模拟网络加载效果）
    var timer: Timer!
    //用了记录当前是否允许加载新数据（正在加载的时候会将其设为false，放置重复加载）
    var loadMoreEnable = true
    
    //0:问题  1:话题  2:点赞
    var type:Int = 0
    
    var infos:[Info] = []
    var infos2:[String] = []
    
    let icon:UIImage = UIImage(named: "no.1")!
    
    //url
    let url:String="https://118.89.166.180:8443"
    let notifiBase0Url:String="/qa-service/questions"
    let notifiBase1Url:String=""
    let notifiBase2Url:String=""
    var loadMoreUrl:String=""
    
    let headers: HTTPHeaders = [
        "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI4Mzc5NDA1OTNAcXEuY29tIiwicm9sZXMiOiJbVVNFUl0iLCJpZCI6MSwiZXhwIjoxNTAwMzYzOTc2fQ.UUWxPoQyf99bwV7vuGVXqVNobEoS2eWOWpqt_Mm_AzNT9lcgWTjNEbOwym4KRVGCMFrLk5vzZFRtyr4jC3N9yg"
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initViewDetail()
        
        //上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(UserHotViewController.footerClick))
        self.tableView.mj_footer = footer
        //上拉加载完全
        self.setupLoadMoreView()
        //下拉刷新
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: #selector(UserHotViewController.headerClick))
        tableView.mj_header = header

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        self.notifiRequest()
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
        //return infos!.count
        return 3
    }
    //返回单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    //创建各单元显示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(2 == self.type){
            let identify:String = "SubList2Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! SubList2Cell
            //            cell.desc.text = infos2[indexPath.row]
            cell.desc.text="xxx 给你的 xxx 点了赞"
            
            return cell
        }
        else{
            let identify:String = "SubListCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! SubListCell
            //            cell.icon.image=infos?[indexPath.row].icon
            //            cell.name.text=infos?[indexPath.row].name
            //            cell.time.text=infos?[indexPath.row].time
            //            cell.title.text=infos?[indexPath.row].title
            //            cell.desc.text=infos?[indexPath.row].desc
            
            cell.icon.image=self.icon
            cell.name.text="wef"
            cell.time.text="2017-03-04"
            cell.title.text="新通知"
            cell.desc.text="新通知的描述"
            
            return cell
        }
    }
    // 点击TableView的一行时调用
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //释放选中效果
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //通知请求
    func notifiRequest(){
        print("in notifiRequest()")
        switch self.type{
        case 0:
            Alamofire.request(url+notifiBase0Url, method: .get, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    print(json)
                    let jsonObj = JSON(data: response.data!)
                    let results:Array = jsonObj["content"].arrayValue
                    self.loadMoreUrl = jsonObj["_links"]["next"]["href"].stringValue
                    
                    if(self.loadMoreUrl.length==0){
                        print("loadMore false")
                        self.loadMoreEnable=false
                    }else {
                        print("loadMore true")
                        self.loadMoreEnable=true
                        self.tableView.tableFooterView = self.clearFooterView
                        self.tableView.mj_footer = self.footer
                        
                    }
                    
                    self.infos.removeAll()
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = self.date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let info = Info(id: id, name: name, time: time, title: title, desc: desc)
                        self.infos.append(info)
                    }
                    self.tableView.reloadData()
                }
            }
            break
        case 1:
            //话题
            Alamofire.request(url+notifiBase1Url, method: .get, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    print(json)
                    let jsonObj = JSON(data: response.data!)
                    let results:Array = jsonObj["content"].arrayValue
                    self.loadMoreUrl = jsonObj["_links"]["next"]["href"].stringValue
                    
                    if(self.loadMoreUrl.length==0){
                        print("loadMore false")
                        self.loadMoreEnable=false
                    }else {
                        print("loadMore true")
                        self.loadMoreEnable=true
                        self.tableView.tableFooterView = self.clearFooterView
                        self.tableView.mj_footer = self.footer
                        
                    }
                    
                    self.infos.removeAll()
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = self.date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let info = Info(id: id, name: name, time: time, title: title, desc: desc)
                        self.infos.append(info)
                    }
                    self.tableView.reloadData()
                }
            }
            break
        case 2:
            //点赞
            Alamofire.request(url+notifiBase2Url, method: .get, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    print(json)
                    let jsonObj = JSON(data: response.data!)
                    let results:Array = jsonObj["content"].arrayValue
                    self.loadMoreUrl = jsonObj["_links"]["next"]["href"].stringValue
                    
                    if(self.loadMoreUrl.length==0){
                        print("loadMore false")
                        self.loadMoreEnable=false
                    }else {
                        print("loadMore true")
                        self.loadMoreEnable=true
                        self.tableView.tableFooterView = self.clearFooterView
                        self.tableView.mj_footer = self.footer
                        
                    }
                    
                    self.infos.removeAll()
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = self.date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let info = Info(id: id, name: name, time: time, title: title, desc: desc)
                        self.infos.append(info)
                    }
                    self.tableView.reloadData()
                }
            }
            break
        default: break
        }
        print("out notifiRequest()")
    }
    //加载更多
    func notifiRequestMore(){
        print("in notifiRequestMore()")
        switch self.type{
        case 0:
            //问题
            Alamofire.request(url+notifiBase0Url+loadMoreUrl, method: .get).responseJSON { response in
                if let json = response.result.value {
                    print(json)
                    let jsonObj = JSON(data: response.data!)
                    let results:Array = jsonObj["content"].arrayValue
                    
                    self.loadMoreUrl = jsonObj["_links"]["next"]["href"].stringValue
                    
                    if(self.loadMoreUrl.length==0){
                        print("loadMore false")
                        self.loadMoreEnable=false
                    }else {
                        print("loadMore true")
                        self.loadMoreEnable=true
                    }
                    
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = self.date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let info = Info(id: id, name: name, time: time, title: title, desc: desc)
                        self.infos.append(info)
                    }
                    self.tableView.reloadData()
                }
            }
            break
        case 1:
            //话题
            Alamofire.request(url+notifiBase0Url+loadMoreUrl, method: .get).responseJSON { response in
                if let json = response.result.value {
                    print(json)
                    let jsonObj = JSON(data: response.data!)
                    let results:Array = jsonObj["content"].arrayValue
                    
                    self.loadMoreUrl = jsonObj["_links"]["next"]["href"].stringValue
                    
                    if(self.loadMoreUrl.length==0){
                        print("loadMore false")
                        self.loadMoreEnable=false
                    }else {
                        print("loadMore true")
                        self.loadMoreEnable=true
                    }
                    
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = self.date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let info = Info(id: id, name: name, time: time, title: title, desc: desc)
                        self.infos.append(info)
                    }
                    self.tableView.reloadData()
                }
            }
            break
        case 2:
            //点赞
            Alamofire.request(url+notifiBase0Url+loadMoreUrl, method: .get).responseJSON { response in
                if let json = response.result.value {
                    print(json)
                    let jsonObj = JSON(data: response.data!)
                    let results:Array = jsonObj["content"].arrayValue
                    
                    self.loadMoreUrl = jsonObj["_links"]["next"]["href"].stringValue
                    
                    if(self.loadMoreUrl.length==0){
                        print("loadMore false")
                        self.loadMoreEnable=false
                    }else {
                        print("loadMore true")
                        self.loadMoreEnable=true
                    }
                    
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = self.date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let info = Info(id: id, name: name, time: time, title: title, desc: desc)
                        self.infos.append(info)
                    }
                    self.tableView.reloadData()
                }
            }
            break
        default:break
        }
        print("out notifiRequest()")
    }
    //上拉加载视图
    private func setupLoadMoreView() {
        self.loadMoreView = UIView(frame: CGRect.init(x: 0, y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: 48))
        self.loadMoreView!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.loadMoreView!.backgroundColor = self.tableView.backgroundColor
        //添加 “没有更多内容“
        let labelX = (self.loadMoreView!.frame.size.width-110)/2
        let labelY = (self.loadMoreView!.frame.size.height-21)/2
        
        self.noMoreRes = UILabel.init(frame: CGRect.init(x: labelX, y: labelY, width: 110.0, height: 21.0))
        self.noMoreRes?.text = "没有更多内容"
        self.noMoreRes?.textAlignment = NSTextAlignment.center
        self.noMoreRes?.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.noMoreRes?.textColor = UIColor.gray
        self.loadMoreView?.addSubview(self.noMoreRes!)
        
        noMoreRes?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
//        //添加中间的环形进度条
//        self.activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
//        self.activityViewIndicator?.color = UIColor.darkGray
//        let indicatorX = (self.loadMoreView!.frame.size.width-(activityViewIndicator?.frame.width)!)/2
//        let indicatorY = (self.loadMoreView!.frame.size.height-(activityViewIndicator?.frame.height)!)/2
//        self.activityViewIndicator?.frame = CGRect.init(x: indicatorX, y: indicatorY,
//                                                        width: (activityViewIndicator?.frame.width)!,
//                                                        height: (activityViewIndicator?.frame.height)!)
//        activityViewIndicator?.startAnimating()
//        self.loadMoreView!.addSubview(activityViewIndicator!)
//        
//        activityViewIndicator?.snp.makeConstraints({ make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        })
        
    }
    
    func headerClick() {
        // 可在此处实现下拉刷新时要执行的代码
        // ......
        self.notifiRequest()
        self.tableView.reloadData()
        if (loadMoreEnable) {
            tableView.tableFooterView = clearFooterView
            tableView.mj_footer = footer
        }else if(!loadMoreEnable) {
            
        }
        // 模拟延迟2秒
        Thread.sleep(forTimeInterval: 2)
        // 结束刷新
        tableView.mj_header.endRefreshing()
    }
    
    func footerClick () {
        // 可在此处实现上拉加载时要执行的代码
        // ......
        //当上拉到底部，执行loadMore()
        if (loadMoreEnable) {
            self.loadMore()
            // 模拟延迟2秒
            Thread.sleep(forTimeInterval: 2)
            // 结束刷新
            tableView.mj_footer.endRefreshing()
        }else if(!loadMoreEnable) {
            //print("should hide")
            // 模拟延迟2秒
            Thread.sleep(forTimeInterval: 2)
            // 结束刷新
            tableView.mj_footer.endRefreshing()
            tableView.mj_footer=nil
            tableView.tableFooterView = loadMoreView
        }
    }
    
    //加载更多数据
    func loadMore(){
        if(loadMoreEnable){
            print("加载新数据！")
            loadMoreEnable = false
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self,
                                         selector: #selector(self.timeOut), userInfo: nil, repeats: true)
        }
    }
    
    //计时器时间到
    func timeOut() {
        //加载更多
        self.notifiRequestMore()
        
        timer.invalidate()
        timer = nil
    }
    //Date to String
    func date2String(dateStamp: Int)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date:Date = NSDate(timeIntervalSince1970:TimeInterval(Int(dateStamp))) as Date
        let dateString = formatter.string(from: date)
        return dateString
    }

}


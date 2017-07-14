//
//  SearchViewController.swift
//  temp
//
//  Created by 王乙飞 on 2017/5/9.
//  Copyright © 2017年 王乙飞. All rights reserved.
//

import UIKit
import CoreData
import MJRefresh
import SwiftyJSON
import Alamofire

let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
let context:NSManagedObjectContext = app.persistentContainer.viewContext

extension String{
    var length: Int { return self.characters.count }
}

class UserHotSearchViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var searchInput: UISearchBar!
    
    @IBOutlet weak var historyTable: UITableView!
    
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
    
    // 是否显示搜索结果
    var isResults:Bool = false
    // 历史记录
    var history:[String] = []
    let historyMax:Int = 6
    // 历史记录匹配的结果，historyTable使用这个数组作为datasource
    var historySel:[String] = []
    // 搜索匹配结果，historyTable也使用这个数组作为datasource
    var resultsSel:[Result] = []
    // 历史记录图标
    let his1Icon:UIImage = UIImage(named: "his1.png")!
    let his2Icon:UIImage = UIImage(named: "his2.png")!
    let icon:UIImage = UIImage(named: "no.1")!
    // cell高度，默认44.0
    var cellHeight:CGFloat = 44.0
    //url
    let url:String="https://118.89.166.180:8443"
    let qaBaseUrl:String="/qa-service"
    let topicBaseUrl:String="/topic-service"
    let studioBaseUrl:String="/studio-service"
    var loadMoreUrl:String=""
    
    let headers: HTTPHeaders = [
        "Authorization": userAuthorization
    ]

    // MARK:- 懒加载属性
    /// 子标题
    lazy var btnNames:[String] = {
        return ["问题","话题","工作室"]
    }()
    
    /// 子标题视图
    lazy var subTitleView: searchSubTitleView = { [unowned self] in
        let view = searchSubTitleView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 40))
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initViewDetail()
        initLayout()
        initScrollView()
        
        authentication()
    }
    
    func initViewDetail(){
        // 起始加载全部内容
        // 搜索框设置文本提示
        self.searchInput.placeholder = "输入搜索信息"
        //设置代理
        self.searchInput.delegate = self
        self.historyTable.delegate = self
        self.historyTable.dataSource = self
        // 注册TableViewCell
        // 注册信息和样式信息全在storyboard里
        //self.historyTable.register(UITableViewCell.self, forCellReuseIdentifier: "HisTitleCell")
        //self.historyTable.register(UITableViewCell.self,forCellReuseIdentifier: "ClrButCell")
        //self.historyTable.register(UITableViewCell.self,forCellReuseIdentifier: "HisListCell")
        //self.historyTable.register(UITableViewCell.self,forCellReuseIdentifier: "ResListCell")
        
        // 隐藏TableView分割线
        self.clearFooterView?.backgroundColor = UIColor.clear
        self.historyTable.tableFooterView = self.clearFooterView
        //上拉加载
        footer.setRefreshingTarget(self, refreshingAction: #selector(UserHotViewController.footerClick))
        //上拉加载完全
        self.setupInfiniteScrollingView()
        //self.historyTable.tableFooterView = self.loadMoreView

    }
    
    func initLayout(){
        
        view.addSubview(subTitleView)
        
        subTitleView.snp.makeConstraints{ make in
            make.top.equalTo(searchInput.snp.bottom)
            make.right.left.equalToSuperview()
            make.height.equalTo(40)
        }
        
        historyTable.snp.makeConstraints{ make in
            make.top.equalTo(subTitleView.snp.bottom)
            make.right.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }
    
    func initScrollView(){
        subTitleView.delegate = self as? searchSubTitleViewDelegate
        subTitleView.titleArray = btnNames
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("search view will appear")
        //获得历史记录
        self.getHistory()
    }
    
    // 返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.isResults){
            return resultsSel.count
        }else if(self.historySel.count==0){
            return 0
        }else{
            return self.historySel.count+2
        }
    }
    
    // 创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 为了提供表格显示性能，已创建完成的单元需重复使用
        // 同一形式的单元格重复使用，在声明时已注册
        self.cellHeight = 44.0
        self.historyTable.mj_footer = nil
        self.historyTable.tableFooterView = self.clearFooterView
        if(isResults){
            self.historyTable.mj_footer = footer
            if(subTitleView.currentSelectedBtn.currentTitle!==btnNames[2]){
                //工作室
                let identify:String = "ResListCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserHotResListCell
                cell.icon.image = icon
                cell.name.text = self.resultsSel[indexPath.row].name
                cell.time.text = self.resultsSel[indexPath.row].time
                cell.title.text = self.resultsSel[indexPath.row].title
                cell.desc.numberOfLines = 3
                cell.desc.lineBreakMode = NSLineBreakMode.byTruncatingTail
                cell.desc.text = self.resultsSel[indexPath.row].desc
                
                // 设置cell高度
                self.cellHeight = 180.0
                
                return cell
            }
            else{
                //问题/话题
                let identify:String = "ResListCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserHotResListCell
                cell.icon.image = icon
                cell.name.text = self.resultsSel[indexPath.row].name
                cell.time.text = self.resultsSel[indexPath.row].time
                cell.title.text = self.resultsSel[indexPath.row].title
                cell.desc.numberOfLines = 3
                cell.desc.lineBreakMode = NSLineBreakMode.byTruncatingTail
                cell.desc.text = self.resultsSel[indexPath.row].desc
                
                // 设置cell高度
                self.cellHeight = 180.0
                
                return cell
            }
        }else if(indexPath.row==0){
            let identify:String = "HisTitleCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserHotHisTitleCell
            cell.hisIcon.image = his1Icon
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }else if(indexPath.row==historySel.count+1){
            let identify:String = "ClrButCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserHotClrButCell
            cell.label.text = "清除历史记录"
            return cell
            
        }else {
            let identify:String = "HisListCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserHotHisListCell
            cell.hisIcon.image = his2Icon
            cell.label.text = self.historySel[indexPath.row-1]
            return cell
        }
    }
    // 自定义TableViewCell的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 计算cell高度
        
        return cellHeight
    }
    
    // 点击TableView的一行时调用
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //释放选中效果
        tableView.deselectRow(at: indexPath, animated: true)
        if(self.isResults){
            //添加历史记录
            self.addHistory()
            
        }else if(indexPath.row==0){
           
        }else if(indexPath.row==historySel.count+1){
            //清除历史记录
            self.clearHistory()
            
            self.historyTable.reloadData()
        }else {
            let cell = tableView.cellForRow(at: indexPath) as! UserHotHisListCell
            searchInput.text=cell.label.text
            self.searchRequest()
            //print(cell!.textLabel?.text!)
        }

        
    }
    
    @IBAction func searchTypeChange(_ sender: Any) {
        if(self.searchInput.text != ""){
            self.searchRequest()
            self.historyTable.reloadData()
        }
    }
    // 搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        isResults=false
        // 没有搜索内容时显示全部组件
        if(searchText.length == 0){
            self.isResults = false
            self.resultsSel = []
        }
        else {
            self.searchRequest()
        }
        // 刷新Table View显示
        self.historyTable.reloadData()
    }
    
    // 搜索代理UISearchBarDelegate方法，点击虚拟键盘上的Search按钮时触发
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //搜索
        self.searchRequest()
        
        //添加历史记录
        self.addHistory()
        
        self.historyTable.reloadData()

    }
    
    //搜索请求
    func searchRequest(){
        print("in searchRequest()")
        
        self.isResults=true
        switch subTitleView.currentSelectedBtn.currentTitle! {
        case btnNames[0]:
            //问题
            Alamofire.request(url+qaBaseUrl+"/questions", method: .get, headers: headers).responseJSON { response in
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
                    
                    self.resultsSel.removeAll()
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let result = Result(id: id, name: name, time: time, title: title, desc: desc)
                        self.resultsSel.append(result)
                    }
                    self.historyTable.reloadData()
                }
            }
            break
        case btnNames[1]:
            //话题
            Alamofire.request(url+topicBaseUrl+"/topic", method: .get, headers: headers).responseJSON { response in
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
                    
                    self.resultsSel.removeAll()
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let result = Result(id: id, name: name, time: time, title: title, desc: desc)
                        self.resultsSel.append(result)
                    }
                    self.historyTable.reloadData()
                }
            }
            break
        case btnNames[2]:
            //工作室
            Alamofire.request(url+studioBaseUrl+"/studio", method: .get, headers: headers).responseJSON { response in
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
                    
                    self.resultsSel.removeAll()
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let result = Result(id: id, name: name, time: time, title: title, desc: desc)
                        self.resultsSel.append(result)
                    }
                    self.historyTable.reloadData()
                }
            }
            break
        default:
            print("没选")
        }
        print("out searchRequestMore()")
    }
    //加载更多
    func searchRequestMore(){
        print("in searchRequestMore()")
        
        self.isResults=true
        switch subTitleView.currentSelectedBtn.currentTitle! {
        case btnNames[0]:
            //问题
            Alamofire.request(url+qaBaseUrl+loadMoreUrl, method: .get, headers:headers).responseJSON { response in
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
                        let time:String = date2String(dateStamp: dateStamp)

                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let result = Result(id: id, name: name, time: time, title: title, desc: desc)
                        self.resultsSel.append(result)
                    }
                    self.historyTable.reloadData()
                }
            }
            break
        case btnNames[1]:
            //话题
            Alamofire.request(url+topicBaseUrl+loadMoreUrl, method: .get, headers:headers).responseJSON { response in
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
                        let time:String = date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let result = Result(id: id, name: name, time: time, title: title, desc: desc)
                        self.resultsSel.append(result)
                    }
                    self.historyTable.reloadData()
                }
            }
            break
        case btnNames[2]:
            //工作室
            Alamofire.request(url+studioBaseUrl+loadMoreUrl, method: .get, headers: headers).responseJSON { response in
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
                    
                    self.resultsSel.removeAll()
                    for r in results{
                        let id:Int = r["id"].intValue
                        let name:String = r["asker"].stringValue
                        
                        //时间戳／ms转为/s
                        let dateStamp = r["date"].intValue/1000
                        // 时间戳转字符串
                        let time:String = date2String(dateStamp: dateStamp)
                        
                        let title:String = r["question"].stringValue
                        let desc:String = r["describtion"].stringValue
                        let result = Result(id: id, name: name, time: time, title: title, desc: desc)
                        self.resultsSel.append(result)
                    }
                    self.historyTable.reloadData()
                }
            }
            break
        default:
            print("没选")
        }
        print("out searchRequest()")
    }
    //历史记录本地持久化
    //获得历史记录
    func getHistory(){
        // 本地数据查询遍历
        // 查询条件设置
        //fetchRequest.fetchLimit = 10 //限定查询结果的数量
        //fetchRequest.fetchOffset = 0 //查询的偏移量
        
        //let predicate = NSPredicate(format: "", "")
        //fetchRequest.predicate = predicate
        
        do {
            let fetchRequest = NSFetchRequest<History>(entityName:"History")
            let fetchedObjects = try context.fetch(fetchRequest)
            //遍历查询的结果
            for his in fetchedObjects{
                self.history.append(his.text!);
            }
            self.historySel = self.history
        }catch {
            fatalError("不能查询：\(error)")
        }
        //self.textList.reloadData()

    }
    //增加一条历史记录
    func addHistory(){
        //本地持久化
        do {
            let fetchRequest = NSFetchRequest<History>(entityName:"History")
            let fetchedObjects = try context.fetch(fetchRequest)
            var isNew:Bool = true
            //遍历查询的结果
            for his in fetchedObjects{
                //更新对象
                if(his.text==searchInput.text){
                    isNew = false
                    break
                }
            }
            if(isNew){
                if(history.count==historyMax){
                    for his in fetchedObjects{
                        //删除对象
                        context.delete(his)
                        break
                    }
                    history.remove(at: 0)
                }
                
                let his = NSEntityDescription.insertNewObject(forEntityName: "History", into: context) as! History
                his.no = Int32(history.count)
                his.text = searchInput.text
                
                do {
                    try context.save()
                    print("保存成功！")
                } catch {
                    fatalError("不能保存：\(error)")
                }
                history.append(searchInput.text!)
            }
            try! context.save()
        } catch {
            fatalError("不能更新：\(error)")
        }
        NSLog("更新成功")
        self.historySel = self.history
    }
    //清空历史记录
    func clearHistory(){
        do {
            let fetchRequest = NSFetchRequest<History>(entityName:"History")
            let fetchedObjects = try context.fetch(fetchRequest)
            
            //遍历查询的结果
            for his in fetchedObjects{
                //删除对象
                context.delete(his)
            }
            //重新保存-更新到数据库
            try! context.save()
            self.historySel.removeAll()
        } catch {
            fatalError("不能更新：\(error)")
        }
        NSLog("删除")
    }
    
    //上拉加载视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect.init(x: 0, y: self.historyTable.contentSize.height, width: self.historyTable.bounds.size.width, height: 48))
        self.loadMoreView!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.loadMoreView!.backgroundColor = self.historyTable.backgroundColor
        //添加 “没有更多内容“
        let labelX = (self.loadMoreView!.frame.size.width-120)/2
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
//                                                  width: (activityViewIndicator?.frame.width)!,
//                                                  height: (activityViewIndicator?.frame.height)!)
//        activityViewIndicator?.startAnimating()
//        self.loadMoreView!.addSubview(activityViewIndicator!)
//        
//        activityViewIndicator?.snp.makeConstraints({ make in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
//        })
        
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
            self.historyTable.mj_footer.endRefreshing()
        }else if(!loadMoreEnable) {
            //print("should hide")
            // 模拟延迟2秒
            Thread.sleep(forTimeInterval: 2)
            // 结束刷新
            self.historyTable.mj_footer.endRefreshing()
            self.historyTable.mj_footer=nil
            self.historyTable.tableFooterView = loadMoreView
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
        self.searchRequestMore()
        
        timer.invalidate()
        timer = nil
    }
//    //Date to String
//    func date2String(dateStamp: Int)->String{
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let date:Date = NSDate(timeIntervalSince1970:TimeInterval(Int(dateStamp))) as Date
//        let dateString = formatter.string(from: date)
//        return dateString
//    }
}


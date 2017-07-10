//
//  SearchViewController.swift
//  temp
//
//  Created by 王乙飞 on 2017/5/9.
//  Copyright © 2017年 王乙飞. All rights reserved.
//

import UIKit
import CoreData

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
    //计数器（用来做延时模拟网络加载效果）
    var timer: Timer!
    //用了记录当前是否允许加载新数据（正则加载的时候会将其设为false，放置重复加载）
    var loadMoreEnable = true
    
    // 是否显示搜索结果
    var isResults:Bool = false
    // 历史记录
    var history:[String] = []
    // 历史记录匹配的结果，historyTable使用这个数组作为datasource
    var historySel:[String] = []
    // 搜索匹配结果，historyTable也使用这个数组作为datasource
    var resultsSel:[String] = []
    // 历史记录图标
    let his1Icon:UIImage = UIImage(named: "his1.png")!
    let his2Icon:UIImage = UIImage(named: "his2.png")!
    let icon:UIImage = UIImage(named: "no.1")!
    // cell高度，默认44.0
    var cellHeight:CGFloat = 44.0
    
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
    }
    
    func initViewDetail(){
        // 起始加载全部内容
        self.historySel = self.history
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
        //上拉刷新视图
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
        self.historyTable.tableFooterView = self.clearFooterView
        if(isResults){
            self.historyTable.tableFooterView = self.loadMoreView
            
            let identify:String = "ResListCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserHotResListCell
            cell.icon.image = icon
            cell.title.text = self.resultsSel[indexPath.row]
            cell.desc.numberOfLines = 3
            cell.desc.lineBreakMode = NSLineBreakMode.byTruncatingTail
            cell.desc.text = "搜索结果的内容／搜索结果的内容／搜索结果的内容／搜索结果的内容／搜索结果的内容／搜索结果的内容／搜索结果的内容／搜索结果的内容／搜索结果的内容／搜索结果的内容／"
            
            
            // 设置cell高度
            self.cellHeight = 154.0
            
            //当下拉到底部，执行loadMore()
            if (loadMoreEnable && indexPath.row == self.resultsSel.count-1) {
                loadMore()
            }
            return cell
        }else if(indexPath.row==0){
            let identify:String = "HisTitleCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath as IndexPath) as! UserHotHisTitleCell
            cell.hisIcon.image = his1Icon
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
            
        }else if(indexPath.row==0){
           
        }else if(indexPath.row==historySel.count+1){
            do {
                let fetchRequest = NSFetchRequest<History>(entityName:"History")
                let fetchedObjects = try context.fetch(fetchRequest)
                
                //遍历查询的结果
                for info in fetchedObjects{
                    //删除对象
                    context.delete(info)
                }
                //重新保存-更新到数据库
                try! context.save()
                self.historySel = []
            } catch {
                fatalError("不能更新：\(error)")
            }
            NSLog("删除\(indexPath.row)")
            self.historyTable.reloadData()
        }else {
            let cell = tableView.cellForRow(at: indexPath) as! UserHotHisListCell
            searchInput.text=cell.label.text
            self.searchRequest()
            self.historyTable.reloadData()
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
            self.historySel = self.history
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
        self.historyTable.reloadData()

    }
    
    func searchRequest(){
        /*authentication()
         let headers: HTTPHeaders = [
         "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJlZXJpY3dlbkBpY2xvdWQuY29tIiwicm9sZXMiOiJbVVNFUl0iLCJpZCI6OSwiZXhwIjoxNDk5NTY1MTg2fQ.Jihs8kp7jVbpju3SyzLCJlIEpqKYbDSnKJy8jiJqsxHSa1z4c_wBaLwBwPo38RMkZJ4rMfjrEV8q8KPk0xU3DQ"
         ]
         Alamofire.request("https://115.159.199.121:8443/recommends?page=0&size=5", method: .get, headers: headers).responseJSON { response in
         if let json = response.result.value {
         print(json)
         }
         }*/

        self.isResults=true
        switch subTitleView.currentSelectedBtn.currentTitle! {
        case btnNames[0]:
            //问题
            self.resultsSel=["问题1"+searchInput.text!,"问题2"+searchInput.text!,"问题3"+searchInput.text!]
            //self.resultsSel.append(contentsOf: ["问题1"+searchInput.text!,"问题2"+searchInput.text!,"问题3"+searchInput.text!])
        case btnNames[1]:
            //话题
            self.resultsSel=["话题1"+searchInput.text!,"话题2"+searchInput.text!,"话题3"+searchInput.text!]
        //self.resultsSel.append(contentsOf: ["话题1"+searchInput.text!,"话题2"+searchInput.text!,"话题3"+searchInput.text!])
        case btnNames[2]:
            //工作室
            self.resultsSel=["工作室1"+searchInput.text!,"工作室2"+searchInput.text!,"工作室3"+searchInput.text!]
            //self.resultsSel.append(contentsOf: ["工作室1"+searchInput.text!,"工作室2"+searchInput.text!,"工作室3"+searchInput.text!])
        default:
            print("没选")
        }
        
    }
    //加载更多
    func searchRequestMore(){
        /*authentication()
         let headers: HTTPHeaders = [
         "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJlZXJpY3dlbkBpY2xvdWQuY29tIiwicm9sZXMiOiJbVVNFUl0iLCJpZCI6OSwiZXhwIjoxNDk5NTY1MTg2fQ.Jihs8kp7jVbpju3SyzLCJlIEpqKYbDSnKJy8jiJqsxHSa1z4c_wBaLwBwPo38RMkZJ4rMfjrEV8q8KPk0xU3DQ"
         ]
         Alamofire.request("https://115.159.199.121:8443/recommends?page=0&size=5", method: .get, headers: headers).responseJSON { response in
         if let json = response.result.value {
         print(json)
         }
         }*/

        
    }
    //改变搜索类型
    func searchRequestType(){
        /*authentication()
         let headers: HTTPHeaders = [
         "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJlZXJpY3dlbkBpY2xvdWQuY29tIiwicm9sZXMiOiJbVVNFUl0iLCJpZCI6OSwiZXhwIjoxNDk5NTY1MTg2fQ.Jihs8kp7jVbpju3SyzLCJlIEpqKYbDSnKJy8jiJqsxHSa1z4c_wBaLwBwPo38RMkZJ4rMfjrEV8q8KPk0xU3DQ"
         ]
         Alamofire.request("https://115.159.199.121:8443/recommends?page=0&size=5", method: .get, headers: headers).responseJSON { response in
         if let json = response.result.value {
         print(json)
         }
         }*/

        
    }
    
    //上拉刷新视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect.init(x: 0, y: self.historyTable.contentSize.height, width: self.historyTable.bounds.size.width, height: 60))
        self.loadMoreView!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.loadMoreView!.backgroundColor = UIColor.clear
        
        //添加中间的环形进度条
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityViewIndicator.color = UIColor.darkGray
        let indicatorX = self.loadMoreView!.frame.size.width/2-activityViewIndicator.frame.width/2
        let indicatorY = self.loadMoreView!.frame.size.height/2-activityViewIndicator.frame.height/2
        activityViewIndicator.frame = CGRect.init(x: indicatorX, y: indicatorY,
                                                  width: activityViewIndicator.frame.width,
                                                  height: activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.loadMoreView!.addSubview(activityViewIndicator)
    }
    //加载更多数据
    func loadMore(){
        print("加载新数据！")
        loadMoreEnable = false
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self,
                                                       selector: #selector(self.timeOut), userInfo: nil, repeats: true)
    }
    
    //计时器时间到
    func timeOut() {
        //搜索
        self.searchRequest()

        self.historyTable.reloadData()
        loadMoreEnable = true
        
        timer.invalidate()
        timer = nil
    }
}


//
//  DetailViewController.swift
//  QACampus2.0
//
//  Created by Eric Wen on 2017/6/2.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Foundation

/* class DetailViewController: UIViewController {
    
    var titleStr: String = ""
    var detailStr: String = ""
    
    let scrollView: UIScrollView = UIScrollView()
    let contentView: UIView = UIView()
    let titleView: UITextView = UITextView()
    let detailView: UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleStr = Detail.title
        detailStr = Detail.detail
        
        configTitleView()
        configDetailView()
        configContentView()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 49 - 64)
        scrollView.backgroundColor = UIColor.white
        scrollView.contentSize = contentView.frame.size
        
        contentView.addSubview(titleView)
        contentView.addSubview(detailView)
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)
    }
    
    func configTitleView() {
        titleView.isEditable = false
        titleView.isScrollEnabled = false
        titleView.font = UIFont.boldSystemFont(ofSize: 30)
        titleView.text = titleStr
        
        let fixedWidth = self.view.frame.width - 40
        titleView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = titleView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newFrame = CGRect(x: 20, y: 20, width: max(newSize.width, fixedWidth), height: newSize.height)
        titleView.frame = newFrame
    }
    
    func configDetailView() {
        detailView.isEditable = false
        detailView.isScrollEnabled = false
        detailView.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
        detailView.text = detailStr
        
        let fixedWidth = self.view.frame.width - 40
        detailView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = detailView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newFrame = CGRect(x: 20, y: titleView.frame.maxY + 20, width: max(newSize.width, fixedWidth), height: newSize.height)
        detailView.frame = newFrame
    }
    
    func configContentView() {
        let height = titleView.frame.height + detailView.frame.height + 60
        let newFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height)
        contentView.frame = newFrame
    }
    
} */

class UserHotDetailViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: UserHotDetailContentCell = self.tableView.dequeueReusableCell(withIdentifier: "contentCell") as! UserHotDetailContentCell
            cell.titleLabel.text = Detail.title
            cell.detailLabel.text = Detail.detail
            cell.titleLabel.sizeToFit()
            cell.detailLabel.sizeToFit()
            return cell
        }
        else {
            let cell: UserHotDetailContentCell = self.tableView.dequeueReusableCell(withIdentifier: "contentCell") as! UserHotDetailContentCell
            cell.titleLabel.text = "foo"
            cell.detailLabel.text = "bar"
            cell.titleLabel.sizeToFit()
            cell.detailLabel.sizeToFit()
            return cell
        }
    }
    
    func configLabelSize(_ label: UILabel) -> CGSize {
        return CGSize()
    }
    
}

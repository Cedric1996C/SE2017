//
//  resetPasswordTableViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/7/11.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit
import Alamofire

class resetPasswordTableViewController: editTableViewController {

    lazy var holder: [String] = {
        return ["请输入原密码","请输入新密码","请重复新密码"]
    }()
    
    var contents:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        saveBtn.action = Selector("reset")
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = sectionHeaderColor
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        view.tintColor = sectionHeaderColor
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath) as! editTableViewCell
            cell.content.placeholder = holder[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reset", for: indexPath) as! resetTableViewCell
            cell.reset.addTarget(self, action: #selector(reset), for: .touchUpInside)
            return cell
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func cancel(sender:Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func reset(sender:Any) {
        
        for i in 0...2 {
            let index = IndexPath(row:i, section: 0)
            let cell = tableView.cellForRow(at:index) as! editTableViewCell
            let txt:String = cell.content.text!
            contents.append(txt)
        }
        
        if contents[1]==contents[2] {
            let parameters: Parameters = [
                "pre_password": contents[0],
                "new_password": contents[1]
            ]
            Alamofire.request("https://\(root):8443/auth/register",method: .post, parameters: parameters).responseString { response in
                debugPrint(response)
            }
        }
        
    }
    
    
}





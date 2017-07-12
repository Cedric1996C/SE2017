//
//  personalStudioViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/12.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class collectStudioViewController: collectQuestionTableViewController {

    lazy var studios:[Studio] = {
        return []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red:255/255,green:235/255,blue:235/255,alpha:1)
       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return studios.count
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectStudio", for: indexPath) as! collectStudioCell
        //        let studio:Studio = studios[indexPath.row]
        //        cell.title.text = studio.title
        //        cell.introduction.text = studio.introduction
        //        cell.avator.image = studio.
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func cancel(sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }


}

//
//  stuidioQuestionViewController.swift
//  QACampus2.0
//
//  Created by NJUcong on 2017/6/29.
//  Copyright © 2017年 Demons. All rights reserved.
//

import UIKit

class studioQuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("new question")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("finish question")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  AwesomePageControl
//
//  Created by 程庆春 on 2016/12/25.
//  Copyright © 2016年 Qiun Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var systemPageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        systemPageControl.addTarget(self, action: #selector(pageControlDidClick(sender:)), for: .valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pageControlDidClick(sender: UIPageControl) {
        print("++++\(sender.currentPage)++++")
    }
    @IBAction func didClickPageControl(_ sender: UIPageControl) {
       
    }

}


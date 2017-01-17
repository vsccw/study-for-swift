//
//  ViewController.swift
//  BarrageView
//
//  Created by yolo on 2017/1/11.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var barrageView: BarrageView!
    var barrages = [Barrage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        barrageView = BarrageView(frame: view.bounds)
        barrageView.add(in: view)
        let messages = ["我是弹幕，我是弹幕，我是弹幕",
                        "老周的数学课第老周一讲”",
                        "猪八戒是哪种性格种性格",
                        
                        "......",
                        "。。。。。",
                        "我是一条弹幕1",
                        "我是一条弹幕我是一条弹幕2",
                        "弹幕3",
                        "弹幕4在这里",
                        "弹幕5",
                        "弹6",
                        "弹幕7",
                        "弹幕弹幕8弹幕",
                        "弹幕9",
                        "我是弹幕，我是弹幕，我是弹幕",
                        "弹幕view的动画执行，部分代码（BulletView.m）如下：",
                        "创建弹幕view，对弹幕view的各种位置状态进行监听并做出相对应的处理。",
                        "哈哈哈哈哈哈哈",
                        "啦啦啦啦啦",
                        "😂😂😂😂",
                        "😰😰😰😰😰",
                        "......",
                        "。。。。。",
                        ]
        let names = ["qiuncheng",
                     "程庆春",
                     "chengqingchun",
                     "vsccw.com",
                     "qiuncheng.com"]
        for message in messages {
            let barrage = Barrage(name: names[messages.count / names.count], avatarUrl: "", message: message)
            barrages.append(barrage)
        }
        
        let button = UIButton(frame: CGRect(x: 5, y: 500, width: UIScreen.main.bounds.width - 10, height: 50))
        button.setTitle("开始", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(beginAnimation(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    @IBAction func beginAnimation(_ sender: Any) {
        barrageView.addNewBarrages(barrages: barrages)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


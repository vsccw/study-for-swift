//
//  SampleTableViewController.swift
//  learn-rx-swift
//
//  Created by 程庆春 on 2017/1/4.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


struct Data {
    let name: String = ""
    let subname: String = ""
}

class SampleTableViewController: UIViewController {

    @IBOutlet weak var simpleTableView: UITableView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.

        let sss = Observable.just(
            (0..<20).map {
                "第\($0)行"
        })
        sss.bindTo(simpleTableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            cell.textLabel?.text = element
        }
        .addDisposableTo(disposeBag)

        simpleTableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] value in
                self?.showAlertView(value: value)

            })
        .addDisposableTo(disposeBag)
    }
    func showAlertView(value: String) {
        let alertView = UIAlertView(
            title: "😃",
            message: "你点击了\(value)",
            delegate: nil,
            cancelButtonTitle: "OK"
        )

        alertView.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

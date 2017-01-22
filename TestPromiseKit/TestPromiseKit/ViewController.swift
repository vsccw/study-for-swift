//
//  ViewController.swift
//  TestPromiseKit
//
//  Created by yolo on 2017/1/22.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchWithPromise().then { result in
            print(result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func fetch(completion: @escaping (Any?, Error?) -> Void) {
        Alamofire.request("", method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let dict):
                completion(dict, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchWithPromise() -> Promise<Any> {
        return Promise(resolvers: { (fulfill, reject) in
            Alamofire.request("http://gank.io/api/day/2015/08/07", method: .get)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let dict):
                        fulfill(dict)
                    case .failure(let error):
                        reject(error)
                    }
            }
        })
    }
}


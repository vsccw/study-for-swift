//
//  ViewController.swift
//  3DPreview
//
//  Created by yolo on 2017/2/4.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var previewButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: previewButton)
        }
        else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let viewController = PreivewViewController()
        return viewController
    }
}


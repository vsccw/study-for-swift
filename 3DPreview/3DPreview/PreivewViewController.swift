//
//  PreivewViewController.swift
//  3DPreview
//
//  Created by yolo on 2017/2/4.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit

class PreivewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view.
    }
    
    lazy var previewActions: [UIPreviewActionItem] = {
        func previewActionForTitle(_ title: String, style: UIPreviewActionStyle = .default) -> UIPreviewAction {
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in
                guard let detailViewController = viewController as? PreivewViewController
                    else { return }
                
                print("previewAction.title triggered from `DetailViewController` for item: sampleTitle")
            }
        }
        
        let action1 = previewActionForTitle("Default Action")
        let action2 = previewActionForTitle("Destructive Action", style: .destructive)
        
        let subAction1 = previewActionForTitle("Sub Action 1")
        let subAction2 = previewActionForTitle("Sub Action 2")
        let groupedActions = UIPreviewActionGroup(title: "Sub Actions…", style: .default, actions: [subAction1, subAction2] )
        
        return [action1, action2, groupedActions]
    }()

    override var previewActionItems: [UIPreviewActionItem] {
        return previewActions
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

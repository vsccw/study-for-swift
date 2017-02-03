//
//  ViewController.swift
//  RxDemo
//
//  Created by yolo on 2017/2/3.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var openGalleryButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap = self.openGalleryButton.rx.tap
        tap.flatMap { [weak self] _ in
            return UIImagePickerController.rx.createWithParent(self, configureImagePicker: { picker in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = false
            })
            .flatMap({ $0.rx.didFinishPickingMediaWithInfo            })
            .take(1)
        }
        .map { info in
            return info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        .bindTo(imageView.rx.image)
        .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


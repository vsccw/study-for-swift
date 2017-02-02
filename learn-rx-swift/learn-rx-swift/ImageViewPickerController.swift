//
//  ImageViewPickerController.swift
//  learn-rx-swift
//
//  Created by yolo on 2017/1/30.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImageViewPickerController: UIViewController {
    @IBOutlet weak var openPickerButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        openPickerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        
    }
}

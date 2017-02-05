//
//  YLQRCodeScanViewController.swift
//  YLQRCode
//
//  Created by yolo on 2017/2/4.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit

class YLQRCodeScanViewController: YLQRScanViewController {
    
    override var resultString: String? {
        didSet {
            print("\(resultString)")
        }
    }
    fileprivate var selectPhotosButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewHeight = view.bounds.height
//        let viewWidth = view.bounds.width
        selectPhotosButton = UIButton(frame: CGRect(x: 35.0, y: viewHeight - 136.0, width: UIScreen.main.bounds.width - 70.0, height: 44.0))
        selectPhotosButton.layer.masksToBounds = true
        selectPhotosButton.layer.cornerRadius = 4.0
        //        selectPhotosButton.setBackgroundImage(UIImage.solidColorImage(fillColor: UIColor.YLYellowColor, size: selectPhotosButton.frame.size), for: .normal)
        selectPhotosButton.backgroundColor = UIColor.yellow
        selectPhotosButton.setTitle("扫描相册中的二维码", for: UIControlState())
        //        selectPhotosButton.setTitleColor(UIColor(ARGBHEX: 0xFF232329), for: .normal)
        selectPhotosButton.setTitleColor(UIColor.black, for: .normal)
        selectPhotosButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        selectPhotosButton.addTarget(self, action: #selector(openAlbumAction(_:)), for: .touchUpInside)
        view.addSubview(selectPhotosButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc fileprivate func openAlbumAction(_ sender: Any) {
        self.stopSessionRunning()
        isFirstPush = false
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerView = UIImagePickerController()
            imagePickerView.allowsEditing = false
            imagePickerView.sourceType = .photoLibrary
            imagePickerView.delegate = self
            present(imagePickerView, animated: true, completion: nil)
        }
    }
}

extension YLQRCodeScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isFirstPush = true
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            YLDetectQRCode.scanQRCodeFromPhotoLibrary(image: image) { [weak self] str in
                if let result = str {
                    YLQRScanCommon.playSound()
                    self?.resultString = result
                }
                else {
                    self?.isFirstPush = false
                    let alertView = UIAlertView(title: "提醒", message: "没有二维码", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                    alertView.show()
                }
            }
        }
    }
}

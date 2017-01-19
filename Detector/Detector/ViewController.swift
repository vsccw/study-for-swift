//
//  ViewController.swift
//  Detector
//
//  Created by yolo on 2017/1/19.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
    
    var imagePickerController: UIImagePickerController?
    var imageView: UIImageView!
    var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let openPhotoButton = UIButton()
        openPhotoButton.setTitle(NSLocalizedString("打开相册", comment: "打开相册"), for: .normal)
        openPhotoButton.layer.cornerRadius = 5.0
        openPhotoButton.layer.masksToBounds = true
        openPhotoButton.backgroundColor = UIColor.yellow
        openPhotoButton.setTitleColor(UIColor.black, for: .normal)
        openPhotoButton.setTitleColor(UIColor.white, for: .highlighted)
        openPhotoButton.addTarget(self, action: #selector(openPhotoButtonClicked), for: .touchUpInside)
        openPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openPhotoButton)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[button]-20-|", options: .alignAllTop, metrics: [:], views: ["view": view, "button": openPhotoButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-64-[button(==44)]", options: .alignAllTop, metrics: [:], views: ["view":view, "button":openPhotoButton]))
        
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 10, height: 10)
        imageView.layer.shadowRadius = 20
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "IMG_0668")
        let tap = UITapGestureRecognizer(target: self, action: #selector(detectorImage))
        imageView.addGestureRecognizer(tap)
        view.addSubview(imageView)
        self.imageView = imageView
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[imageView]-20-|", options: [], metrics: [:], views: ["imageView": imageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[button]-20-[imageView]-150-|", options: [], metrics: [:], views: ["button": openPhotoButton, "imageView": imageView]))
        
        let label = UILabel()
        label.backgroundColor = UIColor.lightGray
        label.text = "No feature."
        label.numberOfLines = 0
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        self.label = label
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[label]-20-|", options: [], metrics: [:], views: ["label": label]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView]-20-[label]-20-|", options: [], metrics: [:], views: ["label": label, "imageView": imageView]))
    }
    
    func detectorImage(image: UIImage?) {
        guard let image = imageView.image, let cgImage = image.cgImage else { return }
        
        
//        guard let cgImage = image.cgImage else { return }
        let ciImage = CIImage(cgImage: cgImage)
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        if let features = detector?.features(in: ciImage) as? [CIFaceFeature] {
            for feature in features {
                DispatchQueue.main.async { [weak self] in
                    self?.label.text = "type: \(feature.type) + bounds: \(feature.bounds) + "
                }
            }
        }
    }
    
    func openPhotoButtonClicked() {
        imagePickerController = UIImagePickerController()
        imagePickerController?.allowsEditing = false
        imagePickerController?.sourceType = .photoLibrary
        imagePickerController?.delegate = self
        present(imagePickerController!, animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        imageView.image = image
        
        detectorImage(image: image)
        
        picker.dismiss(animated: true, completion: {
            picker.delegate = nil
        })
    }
}


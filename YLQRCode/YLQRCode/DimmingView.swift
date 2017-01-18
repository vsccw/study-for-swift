//
//  DimmingView.swift
//  YLQRCode
//
//  Created by yolo on 2017/1/18.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit

internal class DimmingView: UIView {
    
    var rectOfInteract = CGRect(x: 0, y: 0, width: 475.0 * 0.5, height: 475.0 * 0.5) {
        didSet {
            removeAnimations()
            
            for view in subviews {
                view.removeFromSuperview()
            }
            
            for _layer in layer.sublayers! {
                _layer.removeFromSuperlayer()
            }
            
            setup()
        }
    }
    
    private var imageView: UIImageView!
    private var animatableView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        setup()
       
    }
    private func setup() {
        let imageView = UIImageView()
        imageView.frame = rectOfInteract
        imageView.image = #imageLiteral(resourceName: "target_rect")
        addSubview(imageView)
        self.imageView = imageView
        
        let animatableView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width, height: 1))
//        animatableView.image = #imageLiteral(resourceName: "line1")
        animatableView.backgroundColor = UIColor(red: 0.877, green: 0.858, blue: 0.858, alpha: 1.000)
        animatableView.layer.shadowColor = UIColor.black.cgColor
        animatableView.layer.shadowOffset = CGSize(width: 0, height: -3)
        animatableView.layer.shadowRadius = 5
        imageView.addSubview(animatableView)
        self.animatableView = animatableView
        
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = imageView.frame.height
        animation.repeatCount = MAXFLOAT
        animation.duration = 3.0
        animatableView.layer.add(animation, forKey: "moveView.transform.translation.y")
        
        let imageViewOriginX = imageView.frame.origin.x
        let imageViewOriginY = imageView.frame.origin.y
        let imageViewHeight = imageView.frame.height
        let imageViewWidth = imageView.frame.width
        
        let leftLayer = CALayer()
        leftLayer.frame = CGRect(x: 0, y: 0, width: imageViewOriginX, height: frame.height)
        leftLayer.backgroundColor = UIColor(white: 0.0, alpha: 0.92).cgColor
        layer.addSublayer(leftLayer)
        
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: imageViewOriginX, y: 0, width: frame.width - 2 * imageViewOriginX, height: imageViewOriginY)
        topLayer.backgroundColor = UIColor(white: 0.0, alpha: 0.92).cgColor
        layer.addSublayer(topLayer)
        
        let rightLayer = CALayer()
        rightLayer.frame = CGRect(x: imageViewOriginX + imageViewWidth, y: 0, width: imageViewOriginX, height: frame.height)
        rightLayer.backgroundColor = UIColor(white: 0.0, alpha: 0.92).cgColor
        layer.addSublayer(rightLayer)
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: imageViewOriginX, y: imageViewOriginY + imageViewHeight, width: imageViewWidth, height: frame.height - imageViewOriginY - imageViewHeight)
        bottomLayer.backgroundColor = UIColor(white: 0.0, alpha: 0.92).cgColor
        layer.addSublayer(bottomLayer)
    }
    
    func removeAnimations() {
        animatableView.layer.removeAnimation(forKey: "moveView.transform.translation.y")
        animatableView.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

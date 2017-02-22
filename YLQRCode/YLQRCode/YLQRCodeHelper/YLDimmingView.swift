//
//  DimmingView.swift
//  YLQRCode
//
//  Created by yolo on 2017/1/18.
//  Copyright © 2017年 Qiuncheng. All rights reserved.
//

import UIKit

internal struct YLScanViewConfig {
    var scanRectWidthHeight: CGFloat = 235.0
    var centerUpOffset: CGFloat = 77.0
    var borderLineColor: UIColor = UIColor.yellow
//    var dimmingBackgroundColor: UIColor = UIColor()
    var contentOffsetUp: CGFloat = 0.0
    var borderLineWidth: CGFloat = 4.0
    
}

internal class YLDimmingView: UIView {
    
    fileprivate var rectOfInteract = CGRect.zero
    
    private var imageView: UIImageView!
    private var animatableView: UIImageView!
    private var _config: YLScanViewConfig!
    
    private let animatedViewKey = "moveView.transform.translation.y"
    
    internal var config: YLScanViewConfig {
        return _config
    }
    
    convenience init(frame: CGRect, config: YLScanViewConfig = YLScanViewConfig()) {
        self.init(frame: frame)
        let viewWidth = frame.width
        
        _config = config
        _config.contentOffsetUp = UIScreen.main.bounds.height * 0.5 - config.centerUpOffset - config.scanRectWidthHeight * 0.5
        
        rectOfInteract = CGRect(x: (viewWidth - _config.scanRectWidthHeight) * 0.5,
                                y: _config.contentOffsetUp,
                                width: _config.scanRectWidthHeight,
                                height: _config.scanRectWidthHeight)
        setup()
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    private func setup() {
        let imageView = UIImageView()
        imageView.frame = rectOfInteract
        imageView.image = #imageLiteral(resourceName: "Border")
        addSubview(imageView)
        self.imageView = imageView
        
        let animatableView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width, height: 1))
        animatableView.image = #imageLiteral(resourceName: "ScanLineImage")
        animatableView.isHidden = true
        imageView.addSubview(animatableView)
        self.animatableView = animatableView
        
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
    
    func beginAnimation() {
        animatableView.isHidden = false
        guard animatableView.layer.animation(forKey: animatedViewKey) == nil else {
           return
        }
        let animation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.fromValue = 0
        animation.toValue = imageView.frame.height
        animation.repeatCount = MAXFLOAT
        animation.duration = 3.0
        animatableView.layer.add(animation, forKey: animatedViewKey)
    }
    
    func removeAnimations() {
        animatableView.layer.removeAnimation(forKey: animatedViewKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

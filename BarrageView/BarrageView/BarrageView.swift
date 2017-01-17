//
//  YLBulletView.swift
//  QCYOLO
//
//  Created by yolo on 2017/1/11.
//  Copyright © 2017年 qiuncheng.com. All rights reserved.
//

import UIKit
class BarrageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNewBarrages(barrages: [Barrage]) {
        for (index, barrage) in barrages.enumerated() {
            
            let avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            avatarImageView.layer.cornerRadius = 17.5
            avatarImageView.layer.masksToBounds = true
//            avatarImageView.image =
            avatarImageView.backgroundColor = UIColor.random
            
            let textWidth = max(maxWidthWith(str: barrage.message), maxWidthWith(str: barrage.name))
            
            let nameLabel = UILabel(frame: CGRect(x: 35, y: 0, width: textWidth, height: 16.5))
            nameLabel.font = UIFont.systemFont(ofSize: 12)
            nameLabel.textColor = UIColor(red: 255.0/255.0, green: 221.0/255.0, blue: 0/255.0, alpha: 1.0)
            nameLabel.text = barrage.name
            
            let messageLabel = UILabel(frame: CGRect(x: 35, y: 16.5, width: textWidth, height: 16.5))
            messageLabel.font = UIFont.systemFont(ofSize: 12)
            messageLabel.textColor = UIColor.random
            messageLabel.text = barrage.message
            
            let randomIndexForY = CGFloat(arc4random_uniform(1000)) / 1000.0
            let randomIndexForX = CGFloat(arc4random_uniform(1000)) / 1000.0
            let bgView = UIView()
            bgView.frame = CGRect(x: UIScreen.main.bounds.width * (randomIndexForX + 1), y: randomIndexForY * (self.frame.height - 35.0), width: textWidth + 35.0, height: 35.0)
            
            bgView.addSubview(avatarImageView)
            bgView.addSubview(nameLabel)
            bgView.addSubview(messageLabel)
            addSubview(bgView)
            
            var frame = bgView.frame
            let originX = frame.origin.x
            UIView.animate(withDuration: 5.0, delay: 0.5 * TimeInterval(index)
                , options: .curveLinear, animations: {
                frame.origin.x -= (35 + textWidth + originX)
                bgView.frame = frame
            }) { _ in
                bgView.removeFromSuperview()
            }
        }
    }
    
    func stop() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        removeFromSuperview()
    }
    func add(in view: UIView) {
        for subview in view.subviews {
            if subview.isKind(of: BarrageView.self) {
                subview.removeFromSuperview()
            }
        }
        view.addSubview(self)
    }
    
    fileprivate func maxWidthWith(str: String) -> CGFloat {
        let attr = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
        return (str as NSString).boundingRect(with: CGSize(width: 9999, height: 16.5), options: .usesLineFragmentOrigin, attributes: attr, context: nil).width
    }
}

extension UIColor {
    static var random: UIColor {
        let r = CGFloat(arc4random_uniform(256)) / 256.0
        let g = CGFloat(arc4random_uniform(256)) / 256.0
        let b = CGFloat(arc4random_uniform(256)) / 256.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}


struct Barrage {
    var name: String = ""
    var avatarUrl: String = ""
    var message: String = ""
    
    init(name: String, avatarUrl: String, message: String) {
        self.name = name
        self.avatarUrl = avatarUrl
        self.message = message
    }
}

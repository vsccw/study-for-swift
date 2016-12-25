//
//  ViewController.swift
//  PropertyAnimation
//
//  Created by 程庆春 on 2016/12/25.
//  Copyright © 2016年 Qiun Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    weak var circleView: UIView!
    var animator: UIViewPropertyAnimator!
    var previewPoint: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.isUserInteractionEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
        let circleView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        circleView.backgroundColor = UIColor.orange
        circleView.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 - 50)
        circleView.layer.cornerRadius = 10
        circleView.layer.masksToBounds = true
        view.addSubview(circleView)
        self.circleView = circleView
        previewPoint = self.circleView.center

        let times = UICubicTimingParameters(animationCurve: .easeInOut)
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: times)
        self.animator = animator


        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(tap:)))
        self.view.addGestureRecognizer(tap)
    }

    func handleTap(tap: UITapGestureRecognizer) {
        let location = tap.location(in: view)
        animator.addAnimations {
            self.circleView.center = location
        }

        animator.startAnimation()

        animator.addCompletion { [unowned self] _ in
            self.scaleAnimationView()
        }
    }
    func scaleAnimationView() {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.circleView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { [unowned self] (finished) in
            self.circleView.transform = CGAffineTransform.identity
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scaleAnimationView()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first!
        let location = touch.location(in: view)
        animator.addAnimations { 
            self.circleView.center = location
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


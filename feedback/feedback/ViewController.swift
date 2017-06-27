//
//  ViewController.swift
//  feedback
//
//  Created by vsccw on 2017/5/23.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var currentIndex = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    currentIndex = sender.selectedSegmentIndex
  }

  @IBAction func buttonTouched(_ sender: UIButton) {
    switch currentIndex {
    case 1:
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.error)
    case 2:
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
    case 3:
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.warning)
    case 4:
      let generator = UIImpactFeedbackGenerator(style: .light)
      generator.impactOccurred()
    case 5:
      let generator = UIImpactFeedbackGenerator(style: .heavy)
      generator.impactOccurred()
    case 6:
      let generator = UIImpactFeedbackGenerator(style: .medium)
      generator.impactOccurred()
    default:
      let generator = UISelectionFeedbackGenerator()
      generator.selectionChanged()
    }
  }
}


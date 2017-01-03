//
//  ValidationVIewController.swift
//  learn-rx-swift
//
//  Created by 程庆春 on 2017/1/3.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationVIewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let usernameValid = usernameTextField.rx.text.orEmpty
            .map({
                $0.characters.count >= 5
            })
            .shareReplay(1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map({
                $0.characters.count >= 5
            })
            .shareReplay(1)
        let everyThingdValid = Observable
            .combineLatest(usernameValid, passwordValid, resultSelector: {
                $0 && $1
            })
            .shareReplay(1)

        usernameValid.bindTo(usernameLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        usernameValid.bindTo(passwordTextField.rx.isEnabled)
        .addDisposableTo(disposeBag)

        passwordValid.bindTo(passwordLabel.rx.isHidden)
            .addDisposableTo(disposeBag)

        everyThingdValid.bindTo(loginButton.rx.isEnabled)
        .addDisposableTo(disposeBag)

        let titleObservable = Observable<String>.just("🤠")
            .asObservable()
            .shareReplay(1)

        titleObservable
            .bindTo(loginButton.rx.title(for: .normal))
            .addDisposableTo(disposeBag)

//        loginButton.rx.title(for: .normal).onNext("😇") // OR

        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
            self?.showAlertView()
        })
        .addDisposableTo(disposeBag)

        tapGesture.rx.event
            .subscribe { _ in
                self.view.endEditing(true)
            }
            .addDisposableTo(disposeBag)
    }

    func showAlertView() {
        let alertView = UIAlertView(
            title: "😃",
            message: "This is wonderful",
            delegate: nil,
            cancelButtonTitle: "OK"
        )

        alertView.show()
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

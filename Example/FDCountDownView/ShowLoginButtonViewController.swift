//
//  ShowLoginButtonViewController.swift
//  FDCountDownView
//
//  Created by tropsci on 16/5/12.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import FDCountDownView

class ShowLoginButtonViewController: UIViewController {
    
    var loginButtonView: FDLoginView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = CGRectMake(0, 0, 100, 30)
        loginButtonView = FDLoginView(frame: rect, title: "Login")
        loginButtonView.center = view.center
        view.addSubview(loginButtonView)
    }
    
    @IBAction func failureAction(sender: UIButton) {
        if loginButtonView.loadingStatus == .Failure || loginButtonView.loadingStatus == .Success {
            let alertView = UIAlertView(title: "Alert", message: "You need go back and try again", delegate: nil, cancelButtonTitle: "Cancel")
            alertView.show()
            return
        }
        loginButtonView.loadingStatus = .Failure
    }
    
    @IBAction func successAction(sender: UIButton) {
        if loginButtonView.loadingStatus == .Failure || loginButtonView.loadingStatus == .Success {
            let alertView = UIAlertView(title: "Alert", message: "You need go back and try again", delegate: nil, cancelButtonTitle: "Cancel")
            alertView.show()
            return
        }
        loginButtonView.loadingStatus = .Success
    }
    
}

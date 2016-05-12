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
    
    @IBAction func buttonAction(sender: UIButton) {
        
        switch loginButtonView.loadingStatus {
        case .Failure:
            fallthrough
        case .Success:
            let alertView = UIAlertView(title: "Alert", message: "You should go back and try again", delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        case .Loading:
            if sender.titleForState(.Normal) == "Simulate Failure" {
                loginButtonView.loadingStatus = .Failure
            } else if sender.titleForState(.Normal) == "Simulate Success" {
                loginButtonView.loadingStatus = .Success
            }
        case .NoneState:
            let alertView = UIAlertView(title: "Alert", message: "You need tap \"\(loginButtonView.title)\" button firstly.", delegate: nil, cancelButtonTitle: "Cancel")
            alertView.show()
        default:
            break
        }
        
    }
    
}


extension ShowLoginButtonViewController : UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
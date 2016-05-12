//
//  ViewController.swift
//  FDCountDownView
//
//  Created by liuwin7 on 05/10/2016.
//  Copyright (c) 2016 liuwin7. All rights reserved.
//

import UIKit
import FDCountDownView

let presentAdvertisementSegueID = "presentAdvertisementSegueID"
let showLoginButtonViewController = "showLoginButtonViewController"
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showLoginButtonViewController {
            segue.destinationViewController.title = "Login ViewController"
        }
    }
}


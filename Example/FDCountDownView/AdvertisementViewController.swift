//
//  AdvertisementViewController.swift
//  FDCountDownView
//
//  Created by tropsci on 16/5/10.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import FDCountDownView

class AdvertisementViewController: UIViewController {
    
    var countdownView: FDCountDownView!
    
    @IBOutlet weak var adImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCountdownView()
    }
    
    func setupCountdownView() {
        let countdownViewSideLength = CGFloat(30)
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let padding = CGFloat(10)
        let countdownViewFrame = CGRect(x: screenWidth - countdownViewSideLength - padding, y: padding , width: countdownViewSideLength, height: countdownViewSideLength)
        countdownView = FDCountDownView(frame: countdownViewFrame)
        view.addSubview(countdownView)
        countdownView.circleTimeout = 2.5
        countdownView.title = "跳过"
        countdownView.timeoutAction = dismissAdvertisement
        countdownView.tapInAction = dismissAdvertisement
    }
    
    func dismissAdvertisement() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        countdownView.startAnimate()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

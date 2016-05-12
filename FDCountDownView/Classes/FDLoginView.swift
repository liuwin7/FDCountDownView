//
//  FDLoginView.swift
//  Pods
//
//  Created by tropsci on 16/5/11.
//
//

import UIKit

public class FDLoginView: UIView {
    
    public enum FDLoginStatus {
        case NoneState
        case Success
        case Failure
        case Reset
        case Loading
    }
    
    // MARK: - public propertise
    public var loadingStatus: FDLoginStatus = .NoneState {
        didSet {
            switch loadingStatus {
            case .Reset:
                self.animateForReset()
            case .Failure:
                self.animateForFailed()
            case .Success:
                self.animateForSuccess()
            default:
                break
            }
        }
    }
    public var title: String
    
    // MARK: - private properties
    
    private let tapActionSelector = #selector(tapAction(_:))
    private var tapGesture: UITapGestureRecognizer!
    private var backgroundLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    private var isLoading: Bool = false
    private var successLayer: CAShapeLayer?
    private var faliureLayer: CAShapeLayer?
    
    public init(frame: CGRect, title: String) {
        self.title = title
        
        super.init(frame: frame)
        
        setupBackgroundLayer()
        
        setupTextLayer(self.title)
        
        setupTapGesture()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackgroundLayer() {
        backgroundLayer = CAShapeLayer()
        backgroundLayer.frame = self.bounds
        let backgroundStartPath = UIBezierPath(roundedRect: backgroundLayer.bounds, cornerRadius: 5)
        backgroundLayer.path = backgroundStartPath.CGPath
        backgroundLayer.fillColor = UIColor.clearColor().CGColor
        backgroundLayer.strokeColor = UIColor.greenColor().CGColor
        backgroundLayer.lineWidth = 2

        self.layer.addSublayer(backgroundLayer)
    }
    
    private func setupTextLayer(textContent: String) {
        textLayer = CATextLayer()
        textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.string = textContent
        textLayer.fontSize = 16
        let textLayerFrame = CGRectInset(self.bounds, 0, (self.bounds.size.height - textLayer.fontSize) / 4)
        textLayer.frame = textLayerFrame
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.alignmentMode = kCAAlignmentCenter
        self.layer.addSublayer(textLayer)
    }
    
    private func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action:tapActionSelector)
        tapGesture.enabled = true
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action
    
    @objc private func tapAction(tapGestureRecognizer: UITapGestureRecognizer) -> Void {
        if !isLoading {
            
            animateTextLayer()
            
            animateBackgroundLayer()
            
            loadingStatus = .Loading
            
            isLoading = true
        } else {
            
            loadingStatus = .Reset
            
//            animateForSuccess()
//            animateForFailed()
        }
        
    }

    /// animate text layer
    private func animateTextLayer() {
        
        // opacity
        let textLayerAnimation = CABasicAnimation(keyPath: "opacity")
        textLayerAnimation.toValue = 0
        
        // transform.scale
        let shrinkAnimation = CABasicAnimation(keyPath: "transform.scale")
        shrinkAnimation.toValue = 0.4
        
        let textGroupAnimation = CAAnimationGroup()
        textGroupAnimation.animations = [textLayerAnimation, shrinkAnimation]
        textGroupAnimation.duration = 0.75
        textGroupAnimation.removedOnCompletion = false
        textGroupAnimation.fillMode = kCAFillModeBoth
        
        textLayer.addAnimation(textGroupAnimation, forKey: "text animation")
    }

    
    private func animateBackgroundLayer() {
        
        backgroundLayer.removeAllAnimations()
        
        // background layer animation
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "path")
        
        
        // middle 1
        let middleRect1 = CGRectInset(backgroundLayer.bounds, backgroundLayer.bounds.size.width / 6, 0)
        let middlePath1 = UIBezierPath(roundedRect: middleRect1, cornerRadius: 6)
        
        // middle 2
        let middleRect2 = CGRectInset(backgroundLayer.bounds, backgroundLayer.bounds.size.width / 3, 0)
        let middlePath2 = UIBezierPath(roundedRect: middleRect2, cornerRadius: 7)
        
        // end
        let sideLength = min(backgroundLayer.bounds.size.width, backgroundLayer.bounds.size.height)
        let backX = CGRectGetMidX(backgroundLayer.frame) - sideLength / 2
        let backY = CGRectGetMidY(backgroundLayer.frame) - sideLength / 2
        let endBackgroundRect = CGRect(x: backX, y: backY, width: sideLength, height: sideLength)
        let endPath = UIBezierPath(roundedRect: endBackgroundRect, cornerRadius: sideLength / 2 )
        
        keyFrameAnimation.values = [backgroundLayer.path!, middlePath1.CGPath, middlePath2.CGPath, endPath.CGPath]
        keyFrameAnimation.duration = 0.75
        keyFrameAnimation.removedOnCompletion = false
        keyFrameAnimation.fillMode = kCAFillModeBackwards
        keyFrameAnimation.calculationMode = kCAAnimationCubic
        keyFrameAnimation.delegate = self
        backgroundLayer.addAnimation(keyFrameAnimation, forKey: "background animation 1")
        
        // update shape path
        let center = CGPoint(x: CGRectGetMidX(endBackgroundRect), y: CGRectGetMidY(endBackgroundRect))
        let radius = sideLength / 2
        
        let startAnagle = CGFloat(M_PI_4)
        let endAnagle = CGFloat(M_PI) * 2
        let partialCirclePath = UIBezierPath(arcCenter: center,
                                             radius: radius,
                                             startAngle: startAnagle,
                                             endAngle: endAnagle,
                                             clockwise: true)
        self.backgroundLayer.path = partialCirclePath.CGPath
        
        let afterOneSecond = dispatch_time(DISPATCH_TIME_NOW, Int64(750 * USEC_PER_SEC))
        dispatch_after(afterOneSecond, dispatch_get_main_queue()) {
            // keyframe animation for spin the circle
            let values = (0...8).flatMap({ (count) -> CGFloat? in
                CGFloat(M_PI_4) * CGFloat(count)
            })
            let circleKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            circleKeyframeAnimation.values = values
            circleKeyframeAnimation.duration = 1.5
            circleKeyframeAnimation.repeatCount = HUGE
            circleKeyframeAnimation.removedOnCompletion = false
            circleKeyframeAnimation.fillMode = kCAFillModeBoth
            self.backgroundLayer.addAnimation(circleKeyframeAnimation, forKey: "circle keyframe animation")
        }
        
    }
    
    private func animateForReset() {
        if !isLoading {
            return
        }
        
        isLoading = false
        tapGesture.enabled = true
        
        self.successLayer?.removeFromSuperlayer()
        self.faliureLayer?.removeFromSuperlayer()
        
        self.backgroundLayer.removeAllAnimations()

        let sideLength = min(backgroundLayer.bounds.size.width, backgroundLayer.bounds.size.height)
        let backX = CGRectGetMidX(backgroundLayer.frame) - sideLength / 2
        let backY = CGRectGetMidY(backgroundLayer.frame) - sideLength / 2
        let backgroundRect = CGRect(x: backX, y: backY, width: sideLength, height: sideLength)
        
        // init
        let initPath = UIBezierPath(roundedRect: backgroundRect, cornerRadius: sideLength / 2)
        self.backgroundLayer.path = initPath.CGPath
        
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "path")
        // middle 1
        let middleRect1 = CGRectInset(backgroundLayer.bounds, backgroundLayer.bounds.size.width / 3, 0)
        let middlePath1 = UIBezierPath(roundedRect: middleRect1, cornerRadius: 7)

        // middle 2
        let middleRect2 = CGRectInset(backgroundLayer.bounds, backgroundLayer.bounds.size.width / 6, 0)
        let middlePath2 = UIBezierPath(roundedRect: middleRect2, cornerRadius: 6)
        
        // end 
        let endRect = backgroundLayer.bounds
        let endPath = UIBezierPath(roundedRect: endRect, cornerRadius: 5)
        
        keyframeAnimation.values = [initPath.CGPath, middlePath1.CGPath, middlePath2.CGPath, endPath.CGPath]
        keyframeAnimation.duration = 0.75
        keyframeAnimation.removedOnCompletion = false
        keyframeAnimation.fillMode = kCAFillModeBoth
        keyframeAnimation.calculationMode = kCAAnimationCubic
        backgroundLayer.addAnimation(keyframeAnimation, forKey: "background_animation_reset")
        
        backgroundLayer.path = endPath.CGPath
        
        // text reset
        
        // opacity
        let textLayerAnimation = CABasicAnimation(keyPath: "opacity")
        textLayerAnimation.toValue = 1
        
        // transform.scale
        let shrinkAnimation = CABasicAnimation(keyPath: "transform.scale")
        shrinkAnimation.toValue = 1
        
        let textGroupAnimation = CAAnimationGroup()
        textGroupAnimation.animations = [textLayerAnimation, shrinkAnimation]
        textGroupAnimation.duration = 0.75
        textGroupAnimation.removedOnCompletion = false
        textGroupAnimation.fillMode = kCAFillModeBoth
        
        textLayer.addAnimation(textGroupAnimation, forKey: "text animation reset")
    }
    
    private func animateForSuccess() {
        if !isLoading {
            return
        }
        isLoading = false
        tapGesture.enabled = false
        
        let sideLength = min(backgroundLayer.bounds.size.width, backgroundLayer.bounds.size.height)
        let backX = CGRectGetMidX(backgroundLayer.frame) - sideLength / 2
        let backY = CGRectGetMidY(backgroundLayer.frame) - sideLength / 2
        let endBackgroundRect = CGRect(x: backX, y: backY, width: sideLength, height: sideLength)
        self.backgroundLayer.path = UIBezierPath(ovalInRect: endBackgroundRect).CGPath
        
        // add success layer 
        successLayer = CAShapeLayer()
        successLayer?.lineWidth = 2
        successLayer?.frame = endBackgroundRect
        successLayer?.fillColor = UIColor.clearColor().CGColor
        successLayer?.strokeColor = UIColor.greenColor().CGColor
        
        let bezier = UIBezierPath()
        
        let startPoint_X: CGFloat = 2
        let circleRadius = sideLength / 2
        // (x - r)^2 + (y - r)^2 = r^2
        // using max value
        let startPoint_Y = self.yValueFor(startPoint_X, circleRadius: circleRadius, selectMaxValue: true)
        let padding: CGFloat = 4
        let startPoint = CGPoint(x: startPoint_X + 1, y: floor(startPoint_Y) - padding)
        bezier.moveToPoint(startPoint)
        
        let middlePoint = CGPoint(x: sideLength / 2 - 1, y: sideLength - padding)
        bezier.addLineToPoint(middlePoint)
        
        let endPoint_X = sideLength - 2
        let endPoint_Y = self.yValueFor(endPoint_X, circleRadius: circleRadius, selectMaxValue: false)
        let endPoint = CGPoint(x: endPoint_X - 1 , y: floor(endPoint_Y) + padding)
        bezier.addLineToPoint(endPoint)
        successLayer?.path = bezier.CGPath
        
        self.layer.addSublayer(successLayer!)
        
        // animation 
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        keyframeAnimation.values = [0.3, 0.7, 1]
        keyframeAnimation.repeatCount = 1
        keyframeAnimation.fillMode = kCAFillModeBoth
        keyframeAnimation.autoreverses = false
        keyframeAnimation.duration = 0.25
        successLayer?.addAnimation(keyframeAnimation, forKey: "success_keyframe_animation")
    }
    
    private func animateForFailed() {
        if !isLoading {
            return
        }
        isLoading = false
        tapGesture.enabled = false

        let sideLength = min(backgroundLayer.bounds.size.width, backgroundLayer.bounds.size.height)
        let backX = CGRectGetMidX(backgroundLayer.frame) - sideLength / 2
        let backY = CGRectGetMidY(backgroundLayer.frame) - sideLength / 2
        let endBackgroundRect = CGRect(x: backX, y: backY, width: sideLength, height: sideLength)
        self.backgroundLayer.strokeColor = UIColor.redColor().CGColor
        self.backgroundLayer.path = UIBezierPath(ovalInRect: endBackgroundRect).CGPath

        // add failed layer
        faliureLayer = CAShapeLayer()
        faliureLayer?.lineWidth = 2
        faliureLayer?.frame = endBackgroundRect
        faliureLayer?.fillColor = UIColor.clearColor().CGColor
        faliureLayer?.strokeColor = UIColor.redColor().CGColor
        
        let bezier = UIBezierPath()
        
        // from left to right
        let startPoint1_X: CGFloat = 4
        let circleRadius = sideLength / 2
        
        let startPoint_Y = self.yValueFor(startPoint1_X, circleRadius: circleRadius, selectMaxValue: false)
        let padding: CGFloat = 1
        let startPoint1 = CGPoint(x: startPoint1_X + padding, y: floor(startPoint_Y) + padding)
        bezier.moveToPoint(startPoint1)
        
        let endPoint1_X = sideLength - 4
        let endPoint1_Y = self.yValueFor(endPoint1_X, circleRadius: circleRadius, selectMaxValue: true)
        let endPoint1 = CGPoint(x: endPoint1_X - padding, y: endPoint1_Y - padding)
        bezier.addLineToPoint(endPoint1)
        
        // from right to left 
        let startPoint2_X = endPoint1.x
        let startPoint2_Y = startPoint1.y
        let startPoint2 = CGPoint(x: startPoint2_X , y: startPoint2_Y)
        bezier.moveToPoint(startPoint2)
        
        let endPoint2_X = startPoint1.x
        let endPoint2_Y = endPoint1.y
        let endPoint2 = CGPoint(x: endPoint2_X, y: endPoint2_Y)
        bezier.addLineToPoint(endPoint2)
        
        faliureLayer?.path = bezier.CGPath
        self.layer.addSublayer(faliureLayer!)
        
        // animation
        let keyframeAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
        keyframeAnimation.values = [0, 0.25, 0.5, 0.75, 1]
        keyframeAnimation.repeatCount = 1
        keyframeAnimation.fillMode = kCAFillModeBoth
        keyframeAnimation.autoreverses = false
        keyframeAnimation.duration = 0.25
        faliureLayer?.addAnimation(keyframeAnimation, forKey: "failed_keyframe_animation")
    }
    
    //MARK: - Helper
    
    /**
      Calculate the Y value for a X value
     
     - parameter pointX:         a CGFloat the x value of one point
     - parameter circleRadius:   circle radius
     - parameter selectMaxValue: indicate using max value or min value
     
     - returns: return the Y of one point which the X is pointX, if the pointX out of bounds return -1
     */
    private func yValueFor(pointX: CGFloat, circleRadius: CGFloat, selectMaxValue: Bool) -> CGFloat {
        if pointX < 0 || pointX > 2 * circleRadius {
            return -1
        }
        let item = sqrt(pointX * (2 * circleRadius - pointX))
        if selectMaxValue {
            return circleRadius + item
        } else {
            return circleRadius - item
        }
    }
}

extension FDLoginView {
    
    public override func animationDidStart(anim: CAAnimation) {
        self.tapGesture.enabled = false
    }
    
    public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.tapGesture.enabled = true
    }
}

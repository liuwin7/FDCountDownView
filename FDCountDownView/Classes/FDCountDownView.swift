//
//  FDCountDownView.swift
//  Pods
//
//  Created by tropsci on 16/5/10.
//
//

import UIKit

public class FDCountDownView: UIView {
    
    // MARK: - public properties
    
    /// circle color, default is red color
    public var circleColor: UIColor = UIColor.redColor()
    
    /// count down time interval, default 3 seconds
    public var circleTimeout: NSTimeInterval = 3.0
    
    /// circle width, default is 3
    public var circleWidth: CGFloat = 3
    
    /// title in view, default "Jump"
    public var title: String = "Jump" {
        didSet {
           setNeedsLayout()
        }
    }
    
    /// indicate whether hide the view or not, defaut is true.
    public var hideWhenTimeout: Bool = true
    
    /// setup a function, when tap in view, this function will be called.
    public var tapInAction: FDCountDownViewTapAction?
    
    /// setup an action which will be called when the time is out.
    public var timeoutAction: FDCountDownViewTimeoutAction?
    
    
    // MARK: - private properties
    
    private var circleFrame: CGRect!
    private var labelFrame: CGRect!
    private var titleLabel: UILabel?
    private var tapGesture: UITapGestureRecognizer!
    
    private let circleLayer = CAShapeLayer()
    private let tapActionSelector = #selector(tapAction(_:))
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
        setupLayer()
        
        setupTitleLabel()
        
        setupTapGesture()
    }
    
    override public func layoutSubviews() {
        if let titleLabel = self.titleLabel {
            titleLabel.text = title
        }
    }
    
    
    // MARK: - private functions
    
    private func setup() {
        let height = frame.size.height
        let width = frame.size.height
        let sideLength = min(height, width)
        circleFrame = CGRect(x: (width - sideLength) / 2.0, y: (height - sideLength) / 2.0, width: sideLength, height: sideLength)
        labelFrame = CGRectInset(circleFrame, circleWidth * 1.5, circleWidth * 2)
    }
    
    private func setupLayer() {
        circleLayer.frame = circleFrame
        self.layer.addSublayer(circleLayer)
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = circleColor.CGColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 1
        circleLayer.lineWidth = circleWidth
        circleLayer.path = UIBezierPath(ovalInRect: circleLayer.bounds).CGPath
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel(frame: labelFrame)
        titleLabel!.adjustsFontSizeToFitWidth = true
        titleLabel!.textAlignment = .Center
        titleLabel!.text = title
        addSubview(titleLabel!)
    }
    
    private func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action:tapActionSelector)
        tapGesture.enabled = true
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Action
    @objc private func tapAction(tapGestureRecognizer: UITapGestureRecognizer) -> Void {
        if let tapAction = tapInAction {
            tapAction()
        }
    }
    
    public func startAnimate() {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.delegate = self
        strokeEndAnimation.duration = circleTimeout
        strokeEndAnimation.toValue = 0
        strokeEndAnimation.fillMode = kCAFillModeForwards
        strokeEndAnimation.removedOnCompletion = false
        circleLayer.addAnimation(strokeEndAnimation, forKey: "stroke end animation")
    }
    
    // MARK: - alias
    
    public typealias FDCountDownViewTimeoutAction = (()->())
    public typealias FDCountDownViewTapAction = (() -> ())
}

extension FDCountDownView {
    
    override public func animationDidStart(anim: CAAnimation) {
        tapGesture.enabled = true
        print("animation did start")
    }
    
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("animation did stop")
        tapGesture.enabled = false
        if let action = timeoutAction {
            action()
        }
        
        if hideWhenTimeout {
            self.removeFromSuperview()
        }
    }
}

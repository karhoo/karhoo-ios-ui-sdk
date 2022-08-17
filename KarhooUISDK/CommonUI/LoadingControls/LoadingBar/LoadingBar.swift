//
//  LoadingBar.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 12/07/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import UIKit

class LoadingBar: UIView {
    
    enum State {
        case indeterminate
        case determinate(percentage: CGFloat)
        
        var isDeterminate: Bool {
            switch self {
            case .indeterminate:
                return false
            case .determinate:
                return true
            }
        }
    }

    // MARK: - Properties
    
    private lazy var progressBarIndicator = UIView(frame: zeroFrame).then {
        $0.backgroundColor = barColor
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.applyRoundCorners(radius: UIConstants.Dimension.View.loadingBarHeight/2)
    }

    var state: State = .indeterminate
    
    var barColor: UIColor = KarhooUI.colors.secondary {
        didSet {
            progressBarIndicator.backgroundColor = barColor
        }
    }
    
    var barBackgroundColor: UIColor = .clear {
        didSet {
            self.backgroundColor = barBackgroundColor
        }
    }
    
    /*
     By default if the determine state is set before the view is rendered the progress will begin at that value
     If `animateDeterminateInitialization` is True then the progress bar will start at zero and animate to the value.
     */
    var animateDeterminateInitialization: Bool = false
    
    var indeterminateAnimationDuration: TimeInterval = 1.2
    var determinateAnimationDuration: TimeInterval = 1.2
    
    private var zeroFrame: CGRect {
        CGRect(origin: .zero, size: CGSize(width: 0, height: bounds.size.height))
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateForForegroundState()
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window == nil {
            updateForBackgroundState()
        } else {
            updateForForegroundState()
        }
    }
    
    @objc func willMoveToBackground() {
        updateForBackgroundState()
    }
    
    @objc func willEnterForeground() {
        updateForForegroundState()
    }
    
    // MARK: - Setup
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willMoveToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        setupViews()
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = barBackgroundColor
        addSubview(progressBarIndicator)
    }

    // MARK: - Endpoints

    func startAnimation() {
        guard progressBarIndicator.isHidden else { return }
        progressBarIndicator.isHidden = false
        transition(to: state)
    }

    func stopAnimation() {
        progressBarIndicator.isHidden = true
        stopIndeterminateAnimation()
    }
    
    // MARK: - Private methods
    
    private func transition(
        to state: State,
        delay: TimeInterval = 0,
        animateDeterminate: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard window != nil else {
            self.state = state
            return
        }
        
        switch state {
        case .determinate(let percentage):
            stopIndeterminateAnimation()
            animateProgress(toPercent: percentage, delay: delay, animated: animateDeterminate, completion: completion)
        case .indeterminate:
            startIndeterminateAnimation(delay: delay)
            completion?(true)
        }
        
        self.state = state
    }

    private func updateForBackgroundState() {
        stopIndeterminateAnimation()
    }
    
    private func updateForForegroundState() {
        DispatchQueue.main.async {
            self.transition(
                to: self.state,
                animateDeterminate: self.animateDeterminateInitialization
            )
        }
    }
    
    private func animateProgress(
        toPercent percent: CGFloat,
        delay: TimeInterval = 0,
        animated: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: animated ? determinateAnimationDuration : 0,
            delay: delay,
            options: [.beginFromCurrentState],
            animations: { [weak self] in
                guard let self = self else { return }
                self.progressBarIndicator.frame = CGRect(
                    x: 0, y: 0,
                    width: self.bounds.width * percent,
                    height: self.bounds.size.height
                )
            },
            completion: completion
        )
    }
    
    private func stopIndeterminateAnimation() {
        switch state {
        case .indeterminate: moveProgressBarIndicatorToStart()
        case .determinate: break
        }
    }
    
    private func moveProgressBarIndicatorToStart() {
        progressBarIndicator.layer.removeAllAnimations()
        progressBarIndicator.frame = zeroFrame
        progressBarIndicator.layoutIfNeeded()
    }
    
    private func startIndeterminateAnimation(delay: TimeInterval = 0) {
        moveProgressBarIndicatorToStart()
        
        UIView.animateKeyframes(
            withDuration: indeterminateAnimationDuration,
            delay: delay,
            options: [.repeat],
            animations: { [weak self] in
                guard let self = self else { return }
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: self.indeterminateAnimationDuration/2,
                    animations: { [weak self] in
                        guard let self = self else { return }
                        self.progressBarIndicator.frame = CGRect(
                            x: 0,
                            y: 0,
                            width: self.bounds.width * 0.7,
                            height: self.bounds.size.height
                        )
                    })
                
                UIView.addKeyframe(
                    withRelativeStartTime: self.indeterminateAnimationDuration/2,
                    relativeDuration: self.indeterminateAnimationDuration/2,
                    animations: { [weak self] in
                        guard let self = self else { return }
                        self.progressBarIndicator.frame = CGRect(
                            x: self.bounds.width,
                            y: 0,
                            width: self.bounds.width * 0.3,
                            height: self.bounds.size.height
                        )
                        
                    }
                )
            })
    }
}

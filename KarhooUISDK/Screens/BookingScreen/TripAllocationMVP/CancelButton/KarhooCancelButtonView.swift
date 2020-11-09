//
//  KarhooCancelButtonView.swift
//  CancelButton
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHCancelButtonViewID {
    public static let cancelButton = "cancel_button"
    public static let progressLabel = "progress_label"
}

final class KarhooCancelButtonView: UIView, CancelButtonView {

    private var promptLabel: UILabel!
    private var cancelProgressBarContainer: UIView!
    private var cancelProgressView: UIProgressView!
    private var progressLabel: UILabel!
    private var cancelButton: UIButton!
    
    private weak var actions: CancelButtonActions?
    private var timer: Timer = Timer()
    private var touchDownTime: TimeInterval = 0
    private let countingTime: TimeInterval = 0.1
    private let maxProgress: Float = 1

    init() {
        super.init(frame: .zero)
        setUpView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        promptLabel = UILabel()
        promptLabel.translatesAutoresizingMaskIntoConstraints = false
        promptLabel.accessibilityIdentifier = "prompt_label"
        promptLabel.text = UITexts.TripAllocation.cancelInstruction
        promptLabel.font = KarhooUI.fonts.bodyRegular()
        promptLabel.textAlignment = .center
        promptLabel.textColor = .white
        addSubview(promptLabel)
        
        cancelProgressBarContainer = UIView()
        cancelProgressBarContainer.translatesAutoresizingMaskIntoConstraints = false
        cancelProgressBarContainer.accessibilityIdentifier = "cancel_progressBar_container"
        cancelProgressBarContainer.backgroundColor = .clear
        cancelProgressBarContainer.layer.borderColor = UIColor.white.cgColor
        cancelProgressBarContainer.layer.borderWidth = 1.25
        cancelProgressBarContainer.layer.masksToBounds = true
        cancelProgressBarContainer.alpha = 0
        addSubview(cancelProgressBarContainer)
        
        cancelProgressView = UIProgressView(progressViewStyle: .bar)
        cancelProgressView.translatesAutoresizingMaskIntoConstraints = false
        cancelProgressView.accessibilityIdentifier = "progress_view"
        cancelProgressView.transform = CGAffineTransform(scaleX: 1, y: 30)
        cancelProgressView.progressTintColor = .black
        cancelProgressBarContainer.addSubview(cancelProgressView)
        
        progressLabel = UILabel()
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.accessibilityIdentifier = KHCancelButtonViewID.progressLabel
        progressLabel.font = KarhooUI.fonts.bodyRegular()
        progressLabel.textColor = .white
        progressLabel.text = UITexts.Trip.tripCancellingActivityIndicatorText
        cancelProgressBarContainer.addSubview(progressLabel)
        
        cancelButton = UIButton(type: .custom)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.accessibilityIdentifier = KHCancelButtonViewID.cancelButton
        cancelButton.setImage(UIImage.uisdkImage("cancelButton").withRenderingMode(.alwaysTemplate),
                              for: .normal)
        cancelButton.tintColor = .white
        cancelButton.addTarget(self, action: #selector(cancelButtonTouchUpInside), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTouchDown), for: .touchDown)
        cancelButton.addTarget(self, action: #selector(cancelButtonTouchDragExit), for: .touchDragExit)
        cancelButton.addTarget(self, action: #selector(cancelButtonTouchCancel), for: .touchCancel)
        addSubview(cancelButton)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        _ = [promptLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             promptLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 35)].map { $0.isActive = true }
        
        _ = [cancelProgressBarContainer.centerXAnchor.constraint(equalTo: promptLabel.centerXAnchor),
             cancelProgressBarContainer.topAnchor.constraint(equalTo: self.topAnchor,
                                                             constant: 28.0)].map { $0.isActive = true }
        
        _ = [cancelProgressView.leadingAnchor.constraint(equalTo: cancelProgressBarContainer.leadingAnchor),
             cancelProgressView.trailingAnchor.constraint(equalTo: cancelProgressBarContainer.trailingAnchor),
             cancelProgressView.centerYAnchor.constraint(equalTo: cancelProgressBarContainer.centerYAnchor),
             cancelProgressView.widthAnchor.constraint(lessThanOrEqualToConstant: 162.0)].map { $0.isActive = true }
        
        _ = [progressLabel.topAnchor.constraint(equalTo: cancelProgressBarContainer.topAnchor, constant: 8.0),
             progressLabel.bottomAnchor.constraint(equalTo: cancelProgressBarContainer.bottomAnchor, constant: -8.0),
             progressLabel.centerXAnchor.constraint(equalTo: cancelProgressView.centerXAnchor)]
            .map { $0.isActive = true }
        
        let buttonSize: CGFloat = 128.0
        _ = [cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             cancelButton.topAnchor.constraint(equalTo: cancelProgressBarContainer.bottomAnchor),
             cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30.0),
             cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0),
             cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             cancelButton.widthAnchor.constraint(equalToConstant: buttonSize),
             cancelButton.heightAnchor.constraint(equalToConstant: buttonSize)].map { $0.isActive = true }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if cancelProgressBarContainer.layer.cornerRadius != cancelProgressBarContainer.frame.size.height / 2 {
            cancelProgressBarContainer.layer.cornerRadius = cancelProgressBarContainer.frame.size.height / 2
        }
    }

    func set(actions: CancelButtonActions) {
        self.actions = actions
    }

    func reset() {
        resetCancelState()
    }

    @objc
    private func cancelButtonTouchDown() {
        if cancelProgressView.progress == maxProgress {
            return
        }
        startCancelCountdown()
    }

    @objc
    private func cancelButtonTouchUpInside() {
        stopCancelCountdown()
    }

    @objc
    private func cancelButtonTouchDragExit() {
        stopCancelCountdown()
    }

    @objc
    private func cancelButtonTouchCancel() {
        stopCancelCountdown()
    }

    private func setProgress() {
        touchDownTime += countingTime

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }

            self.cancelProgressView.setProgress(Float(self.touchDownTime), animated: true)
        }

        if cancelProgressView.progress == maxProgress {
            timer.invalidate()
            actions?.userRequestedTripCancellation()
        }
    }

    private func startCancelCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: countingTime,
                                     repeats: true) { [weak self] _ in
                                        self?.setProgress()
        }

        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.cancelProgressBarContainer.alpha = 1
            self?.promptLabel.alpha = 0
            self?.cancelButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        })
    }

    private func stopCancelCountdown() {
        timer.invalidate()

        guard cancelProgressView.progress != maxProgress else {
            return
        }

        resetCancelState()
    }

    private func resetCancelState() {
        timer.invalidate()
        cancelProgressView.progress = 0
        touchDownTime = 0

        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.cancelProgressBarContainer.alpha = 0
            self?.promptLabel.alpha = 1
            self?.cancelButton.transform = .identity
        })

    }
}

//
//  KarhooBookingAllocationSpinner.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreGraphics
import UIKit

public struct KHBookingAllocationSpinnerID {
    public static let spinnerImage = "spinner_image"
}

final class KarhooBookingAllocationSpinner: UIView, BookingAllocationSpinnerView {

    private var spinnerImageView: UIImageView!
    private var circlePath: CGMutablePath?
    private var largeCirclePath: CGMutablePath?
    private var presenter: KarhooBookingAllocationSpinnerPresenter?
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        accessibilityIdentifier = "allocation_spinner_view"
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = UIColor.black.withAlphaComponent(0.70)
        alpha = 0
        presenter = KarhooBookingAllocationSpinnerPresenter(view: self)
        
        spinnerImageView = UIImageView(image: UIImage.uisdkImage("kh_uisdk_allocating_spinner"))
        spinnerImageView.translatesAutoresizingMaskIntoConstraints = false
        spinnerImageView.accessibilityIdentifier = KHBookingAllocationSpinnerID.spinnerImage
        addSubview(spinnerImageView)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        _ = [spinnerImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             spinnerImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50.0),
             spinnerImageView.widthAnchor.constraint(equalToConstant: 212.0),
             spinnerImageView.heightAnchor.constraint(equalToConstant: 212.0)].map { $0.isActive = true }
    }

    deinit {
        presenter?.stopMonitoringAppState()
    }

    func fadeInAndAnimate() {
        presenter?.startMonitoringAppState()

        removeAllAnimations()
        setupMaskLayer()

        let maskAnimation = createFadeInMaskAnimation()
        layer.mask?.add(maskAnimation, forKey: "fadeInAnimation")

        startRotation()

        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.alpha = 1
            }, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut,
                       animations: { [weak self] in
                        self?.spinnerImageView?.alpha = 1
            }, completion: nil)
    }

    func startRotation() {
        let spinningAnimation = createSpinningAnimation()
        spinnerImageView.layer.add(spinningAnimation, forKey: "rotation")
    }

    func stopRotation() {
        spinnerImageView.layer.removeAllAnimations()
    }

    func fadeOut() {
        presenter?.stopMonitoringAppState()

        let maskAnimation = createFadeOutMaskAnimation()
        layer.mask?.add(maskAnimation, forKey: "fadeOutAnimation")

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.spinnerImageView?.alpha = 0
            }, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.alpha = 0
            }, completion: { [weak self] _ in
                self?.removeAllAnimations()
        })
    }

    private func setupMaskLayer() {
        guard let spinnerImageView = self.spinnerImageView else {
            return
        }

        let xOffset: CGFloat = spinnerImageView.center.x
        let yOffset: CGFloat = spinnerImageView.center.y
        let radius: CGFloat = spinnerImageView.frame.width/2 - 5

        let circlePath = CGMutablePath()
        circlePath.addArc(center: CGPoint(x: xOffset, y: yOffset),
                          radius: radius,
                          startAngle: 0.0,
                          endAngle: 2.0 * .pi,
                          clockwise: false)
        circlePath.addRect(CGRect(origin: .zero, size: frame.size))
        self.circlePath = circlePath

        let largeCirclePath = CGMutablePath()
        largeCirclePath.addArc(center: CGPoint(x: xOffset, y: yOffset),
                               radius: radius*4,
                               startAngle: 0.0,
                               endAngle: 2.0 * .pi,
                               clockwise: false)
        largeCirclePath.addRect(CGRect(origin: .zero, size: frame.size))
        self.largeCirclePath = largeCirclePath

        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = circlePath
        maskLayer.fillRule = .evenOdd
        layer.mask = maskLayer
    }

    // MARK: - Animations

    private func createSpinningAnimation() -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.6, 0.9, 0.8, 0.6)
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }

    private func createFadeInMaskAnimation() -> CAAnimation {
        guard let circlePath = self.circlePath,
            let largeCirclePath = self.largeCirclePath else {
                return CAAnimation()
        }

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = largeCirclePath
        animation.toValue = circlePath
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        return animation
    }

    private func createFadeOutMaskAnimation() -> CAAnimation {
        guard let circlePath = self.circlePath,
            let largeCirclePath = self.largeCirclePath else {
                return CAAnimation()
        }

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = circlePath
        animation.toValue = largeCirclePath
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.isRemovedOnCompletion = false
        return animation
    }

    private func removeAllAnimations() {
        layer.mask?.removeAllAnimations()
        spinnerImageView.layer.removeAllAnimations()
    }
}

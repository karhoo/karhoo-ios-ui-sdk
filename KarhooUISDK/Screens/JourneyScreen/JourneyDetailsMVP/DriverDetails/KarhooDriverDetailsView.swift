//
//  DriverDetailsView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

final class KarhooDriverDetailsView: NibLoadableView, DriverDetailsView {

    @IBOutlet private weak var driverNameLabel: UILabel!
    @IBOutlet private weak var driverNameLabelTopLC: NSLayoutConstraint!
    @IBOutlet private weak var driverImageView: UIImageView!
    @IBOutlet private weak var driverImageViewShadow: UIView!

    private var smallImageFrame: CGRect = .zero

    init(driverName: String?,
         driverImage: UIImage) {
        super.init(frame: .zero)
        driverNameLabel.text = driverName
        driverImageView.image = driverImage
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startAnimation(fromSmallImageView smallImageView: UIView) {
        guard let smallImageSuperview = smallImageView.superview else {
            return
        }

        driverNameLabel.alpha = 0
        driverNameLabel.layoutIfNeeded()

        smallImageFrame = smallImageSuperview.convert(smallImageView.frame, to: self)
        let driverImageOriginalFrame = driverImageView.frame
        driverImageView.frame = smallImageFrame

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.driverImageView.frame = driverImageOriginalFrame
            self?.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        }, completion: { [weak self] _ in
            self?.animateDriverName()
        })
    }

    private func animateDriverName() {
        driverNameLabel.alpha = 1
        driverNameLabelTopLC.constant = 8
        driverNameLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: { [weak self] in
            self?.driverNameLabel.transform = .identity
            self?.layoutIfNeeded()
        }, completion: { _ in

        })
    }

    @IBAction private func overlayTapped() {
        fadeOut()
    }

    private func fadeOut() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.driverImageView.frame = self.smallImageFrame
            self.backgroundColor = .clear
            self.driverNameLabel.alpha = 0

        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
    }
}

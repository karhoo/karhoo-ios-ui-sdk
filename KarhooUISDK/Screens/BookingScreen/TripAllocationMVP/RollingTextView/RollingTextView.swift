//
//  RollingTextView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

final class RollingTextView: UIView {

    private var mainLabel: UILabel!
    private var subLabel: UILabel!

    private var animating = false
    private var subtitles: [String] = []
    private var currentPosition = -1

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        clipsToBounds = false
        
        mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.accessibilityIdentifier = "main_label"
        mainLabel.textColor = .white
        mainLabel.textAlignment = .center
        mainLabel.font = KarhooUI.fonts.subtitleBold()
        mainLabel.alpha = 0
        mainLabel.minimumScaleFactor = 0.5
        addSubview(mainLabel)
        
        subLabel = UILabel()
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.accessibilityIdentifier = "sub_label"
        subLabel.textColor = .white
        subLabel.textAlignment = .center
        subLabel.font = KarhooUI.fonts.bodyRegular()
        subLabel.alpha = 0
        subLabel.numberOfLines = 0
        addSubview(subLabel)
        
        setUpConstraints()
    }
        
    private func setUpConstraints() {
        _ = [mainLabel.topAnchor.constraint(equalTo: self.topAnchor),
             mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             mainLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
             mainLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor)].map { $0.isActive = true }
        
        _ = [subLabel.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor),
             subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 5.0),
             subLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
             subLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
             subLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor)].map { $0.isActive = true }
    }
    
    func animate(title: String, subtitles: [String]) {
        guard animating == false else {
            return
        }
        animating = true
        currentPosition = 0
        self.subtitles = subtitles
        mainLabel.text = title
        subLabel.text = getNextSubtitle()

        mainLabel.transform = CGAffineTransform(translationX: 0, y: frame.height / 4)

        subLabel.transform = minimizeTransform
        subLabel.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
            self?.mainLabel.alpha = 1
        }, completion: { _ in

        })

        UIView.animate(withDuration: 0.3, delay: 4, options: .curveEaseIn,
                       animations: { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.mainLabel.transform = .identity
                        self.subLabel.transform = .identity
                        self.subLabel.alpha = 1
        }, completion: { _ in
            self.minimizeSublabel()
        })
    }

    func stopAnimation() {
        animating = false
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.alpha = 0
        }
    }

    private func minimizeSublabel() {
        guard animating else {
            return
        }
        UIView.animate(withDuration: 0.2, delay: 3, options: .curveEaseIn,
                       animations: { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.subLabel.transform = self.minimizeTransform
                        self.subLabel.alpha = 0
            }, completion: { [weak self] _ in
                self?.enlargeAndUpdateSublabel()
        })
    }

    private func enlargeAndUpdateSublabel() {
        guard animating else {
            return
        }
        self.subLabel.text = getNextSubtitle()

        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.subLabel.transform = .identity
                        self?.subLabel.alpha = 1
            }, completion: { [weak self] _ in
                self?.minimizeSublabel()
        })
    }

    private func getNextSubtitle() -> String {
        currentPosition = (currentPosition + 1 >= subtitles.count ? 0 : currentPosition + 1)
        return subtitles[currentPosition]
    }

    private var minimizeTransform: CGAffineTransform {
        let transformation = CGAffineTransform(scaleX: 0.2, y: 0.2)
        return transformation.translatedBy(x: 0, y: 500)
    }
}

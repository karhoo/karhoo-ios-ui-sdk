//
//  KarhooGradients.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import UIKit

struct KarhooGradients {

    func primaryGradient() -> CAGradientLayer {
        let primaryGradient = regularGradientLayer()
        primaryGradient.colors = primaryGradientColours
        return primaryGradient
    }

    func secondaryGradient() -> CAGradientLayer {
        let secondaryGradient = regularGradientLayer()
        secondaryGradient.colors = secondaryGradientColours
        return secondaryGradient
    }

    func tertiaryGradient() -> CAGradientLayer {
        let tertiaryGradient = regularGradientLayer()
        tertiaryGradient.colors = tertiaryGradientColours
        return tertiaryGradient
    }

    func quarternaryGradient() -> CAGradientLayer {
        let quarternaryGradient = regularGradientLayer()
        quarternaryGradient.colors = quarternaryGradientColours
        return quarternaryGradient
    }

    func quinaryGradient() -> CAGradientLayer {
        let quinaryGradient = regularGradientLayer()
        quinaryGradient.colors = quinaryGradientColours
        return quinaryGradient
    }

    func navigationBarGradient() -> CAGradientLayer {
        let navigationGradient = topToBottomGradientLayer()
        navigationGradient.colors = navigationColours
        navigationGradient.locations = [0.0, 0.70, 0.90, 0.0]
        return navigationGradient
    }

    func whiteTopToBottomGradient() -> CAGradientLayer {
        let navigationGradient = topToBottomGradientLayer()
        navigationGradient.colors = [UIColor(white: 1.0, alpha: 1).cgColor,
                                     UIColor(white: 1.0, alpha: 0).cgColor]
        return navigationGradient
    }

    func whiteOffWhiteGradient() -> CAGradientLayer {
        let whiteOffWhiteGradient = topToBottomGradientLayer()
        whiteOffWhiteGradient.colors = whiteOffWhiteGradientColours
        return whiteOffWhiteGradient
    }

    private func topToBottomGradientLayer() -> CAGradientLayer {
        let topToBottomGradient = CAGradientLayer()
        topToBottomGradient.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        topToBottomGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        topToBottomGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        return topToBottomGradient
    }

    private func regularGradientLayer() -> CAGradientLayer {
        let regularGradient = CAGradientLayer()
        regularGradient.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        regularGradient.startPoint = CGPoint(x: 1.0, y: 0.5)
        regularGradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        return regularGradient
    }

    private var primaryGradientColours: [CGColor] {
        return [KarhooUI.colors.secondary.cgColor,
                KarhooUI.colors.primary.cgColor]
    }

    private var secondaryGradientColours: [CGColor] {
        return [UIColor(red: 0.0, green: 229.0/255.0, blue: 0.0, alpha: 1).cgColor,
                UIColor(red: 0.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1).cgColor]
    }

    private var tertiaryGradientColours: [CGColor] {
        return [UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1).cgColor,
                UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1).cgColor]
    }

    private var quarternaryGradientColours: [CGColor] {
        return [UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1).cgColor,
                UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1).cgColor]
    }

    private var quinaryGradientColours: [CGColor] {
        return [UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1).cgColor,
                UIColor(red: 250.0/255.0, green: 0.0, blue: 70.0/255.0, alpha: 1).cgColor]
    }

    private var navigationColours: [CGColor] {
        return [UIColor(white: 1.0, alpha: 1).cgColor,
                UIColor(white: 1.0, alpha: 0.80).cgColor,
                UIColor(white: 1.0, alpha: 0.40).cgColor,
                UIColor(white: 1.0, alpha: 0.0).cgColor]

    }

    private var whiteOffWhiteGradientColours: [CGColor] {
        return [KarhooUI.colors.white.cgColor, KarhooUI.colors.background1.cgColor]
    }
}

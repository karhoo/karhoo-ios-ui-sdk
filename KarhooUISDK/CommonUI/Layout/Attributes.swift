//
//  Attributes.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import QuartzCore

public final class Attributes: UIView {

    // MARK: - UIView size
    @IBOutlet public var onePixelHeight: [NSLayoutConstraint]?
    @IBOutlet public var onePixelWidth: [NSLayoutConstraint]?

    // MARK: - UIView colours
    @IBOutlet public var overlayBackgroundColor: [UIView]?
    @IBOutlet public var white95BackgroundColor: [UIView]?
    @IBOutlet public var offWhiteBackgroundColor: [UIView]?
    @IBOutlet public var lightGreyBackgroundColor: [UIView]?
    @IBOutlet public var primaryBackgroundColor: [UIView]?
    @IBOutlet public var secondaryBackgroundColor: [UIView]?

    // MARK: - UIViews effects
    @IBOutlet public var standardRoundedCorners: [UIView]?
    @IBOutlet public var mediumRoundedCorners: [UIView]?
    @IBOutlet public var largeRoundedCorners: [UIView]?
    @IBOutlet public var standardShadow: [UIView]?
    @IBOutlet public var viewWithBorder: [UIView]?
    @IBOutlet public var circularView: [UIView]?

    // MARK: - UIImageViews tint colours
    @IBOutlet public var primaryImageTint: [UIImageView]?
    @IBOutlet public var secondaryImageTint: [UIImageView]?
    @IBOutlet public var whiteImageTint: [UIImageView]?
    @IBOutlet public var medGreyImageTint: [UIImageView]?

    // MARK: - UIlabel fonts
    @IBOutlet public var headerRegular: [UILabel]?
    @IBOutlet public var headerBold: [UILabel]?
    @IBOutlet public var bodyRegular: [UILabel]?
    @IBOutlet public var bodyBold: [UILabel]?
    @IBOutlet public var captionRegular: [UILabel]?
    @IBOutlet public var captionBold: [UILabel]?
    @IBOutlet public var footnoteRegular: [UILabel]?
    @IBOutlet public var footnoteBold: [UILabel]?
    @IBOutlet public var titleRegular: [UILabel]?
    @IBOutlet public var titleBold: [UILabel]?
    @IBOutlet public var subtitleRegular: [UILabel]?
    @IBOutlet public var subtitleBold: [UILabel]?

    // MARK: - UILabel text colours
    @IBOutlet public var darkGreyFontColour: [UILabel]?
    @IBOutlet public var medGreyFontColour: [UILabel]?
    @IBOutlet public var primaryFontColour: [UILabel]?
    @IBOutlet public var secondaryFontColour: [UILabel]?

    // MARK: - UIButtons fonts
    @IBOutlet public var buttonFontSubtitleBold: [UIButton]?
    @IBOutlet public var buttonFontBodyRegular: [UIButton]?
    @IBOutlet public var buttonFontBodyBold: [UIButton]?
    @IBOutlet public var buttonFontHeaderRegular: [UIButton]?
    @IBOutlet public var buttonFontHeaderBold: [UIButton]?

    // MARK: - UITextField palceholder color
    @IBOutlet public var textfieldPlaceholderMedGrey: [UITextField]?

    // MARK: - UISwitch onTint color
    @IBOutlet public var switchOnTintColorSecondary: [UISwitch]?

    // MARK: - UIActivityIndicator tint color
    @IBOutlet public var activityIndicatorColor: [UIActivityIndicatorView]?

    static let standardCornerRadius: CGFloat = 4
    static let mediumCornerRadius: CGFloat = 8
    static let largeCornerRadius: CGFloat = 12

    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {

        // MARK: - UIView size
        setValue(CGFloat(0.5), forKeyPath: "onePixelHeight.constant")
        setValue(CGFloat(0.5), forKeyPath: "onePixelWidth.constant")

        // MARK: - UIView colours
        setValue(KarhooUI.colors.white95, forKeyPath: "white95BackgroundColor.backgroundColor")
        setValue(KarhooUI.colors.offWhite, forKeyPath: "offWhiteBackgroundColor.backgroundColor")
        setValue(KarhooUI.colors.offWhite, forKeyPath: "overlayBackgroundColor.backgroundColor")
        setValue(KarhooUI.colors.lightGrey, forKeyPath: "lightGreyBackgroundColor.backgroundColor")
        setValue(KarhooUI.colors.primary, forKeyPath: "primaryBackgroundColor.backgroundColor")
        setValue(KarhooUI.colors.secondary, forKeyPath: "secondaryBackgroundColor.backgroundColor")

        // MARK: - UIView effects
        standardRoundedCorners?.forEach({ (view: UIView) in
            view.layer.cornerRadius = Attributes.standardCornerRadius
        })

        mediumRoundedCorners?.forEach({ (view: UIView) in
            view.layer.cornerRadius = Attributes.mediumCornerRadius
        })

        largeRoundedCorners?.forEach({ (view: UIView) in
            view.layer.cornerRadius = Attributes.largeCornerRadius
        })

        standardShadow?.forEach({ (view: UIView) in
            view.layer.masksToBounds = false
            view.layer.shadowOffset = CGSize(width: 0, height: 2)
            view.layer.shadowRadius = Attributes.standardCornerRadius
            view.layer.shadowOpacity = 0.3
            // Below line speeds up the drawing of the shadows massively. 
            // However, the bounds of the view is not properly set at this stage
            // view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        })

        viewWithBorder?.forEach({ (view: UIView) in
            view.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
            view.layer.borderWidth = 1
        })

        circularView?.forEach({ (view: UIView) in
            view.layer.cornerRadius = view.frame.size.height / 2
            view.layer.masksToBounds = true
        })
        // UIImageView - tint colours
        setValue(KarhooUI.colors.primary, forKeyPath: "primaryImageTint.tintColor")
        setValue(KarhooUI.colors.secondary, forKeyPath: "secondaryImageTint.tintColor")
        setValue(KarhooUI.colors.white, forKeyPath: "whiteImageTint.tintColor")
        setValue(KarhooUI.colors.textLabel, forKeyPath: "medGreyImageTint.tintColor")

        // UILabel - fonts
        setValue(KarhooUI.fonts.headerRegular(), forKeyPath: "headerRegular.font")
        setValue(KarhooUI.fonts.headerBold(), forKeyPath: "headerBold.font")
        setValue(KarhooUI.fonts.bodyRegular(), forKeyPath: "bodyRegular.font")
        setValue(KarhooUI.fonts.bodyBold(), forKeyPath: "bodyBold.font")
        setValue(KarhooUI.fonts.captionRegular(), forKeyPath: "captionRegular.font")
        setValue(KarhooUI.fonts.captionBold(), forKeyPath: "captionBold.font")
        setValue(KarhooUI.fonts.footnoteRegular(), forKeyPath: "footnoteRegular.font")
        setValue(KarhooUI.fonts.footnoteBold(), forKeyPath: "footnoteBold.font")
        setValue(KarhooUI.fonts.titleRegular(), forKeyPath: "titleRegular.font")
        setValue(KarhooUI.fonts.titleBold(), forKeyPath: "titleBold.font")
        setValue(KarhooUI.fonts.subtitleRegular(), forKeyPath: "subtitleRegular.font")
        setValue(KarhooUI.fonts.subtitleBold(), forKeyPath: "subtitleBold.font")

        // MARK: - UILabel text colours
        setValue(KarhooUI.colors.text, forKeyPath: "darkGreyFontColour.textColor")
        setValue(KarhooUI.colors.textLabel, forKeyPath: "medGreyFontColour.textColor")
        setValue(KarhooUI.colors.primary, forKeyPath: "primaryFontColour.textColor")
        setValue(KarhooUI.colors.secondary, forKeyPath: "secondaryFontColour.textColor")

        // UIButtons- font
        setValue(KarhooUI.fonts.subtitleBold(), forKeyPath: "buttonFontSubtitleBold.font")
        setValue(KarhooUI.fonts.bodyRegular(), forKeyPath: "buttonFontBodyRegular.font")
        setValue(KarhooUI.fonts.headerRegular(), forKeyPath: "buttonFontHeaderRegular.font")
        setValue(KarhooUI.fonts.headerBold(), forKeyPath: "buttonFontHeaderBold.font")
        setValue(KarhooUI.fonts.bodyBold(), forKeyPath: "buttonFontBodyBold.font")

        // UITextField palceholder color
        setValue(KarhooUI.colors.textLabel, forKeyPath: "textfieldPlaceholderMedGrey.placeholderLabel.textColor")

        // UISwitch onTint color
        setValue(KarhooUI.colors.secondary, forKeyPath: "switchOnTintColorSecondary.onTintColor")

        // MARK: - UIActivityIndicator tint color
        setValue(KarhooUI.colors.primary, forKeyPath: "activityIndicatorColor.color")

    }
}

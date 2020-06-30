//
//  KarhooFonts.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public struct FontFamily {
    let boldFont: String
    let regularFont: String
    let lightFont: String
    
    public init(boldFont: String = "",
                regularFont: String = "",
                lightFont: String = "") {
        self.boldFont = boldFont
        self.regularFont = regularFont
        self.lightFont = lightFont
    }
}

struct KarhooFonts {

    private let titleSize: CGFloat = 30
    private let subtitleSize: CGFloat = 20
    private let fontSize24: CGFloat = 24
    private let headerSize: CGFloat = 17
    private let bodySize: CGFloat = 15
    private let captionSize: CGFloat = 12
    private let footnoteSize: CGFloat = 10
    
    private var boldFont: UIFont = UIFont.systemFont(ofSize: 0, weight: .bold)
    private var regularFont: UIFont = UIFont.systemFont(ofSize: 0, weight: .regular)
    private var lightFont: UIFont = UIFont.systemFont(ofSize: 0, weight: .light)

    init(family: FontFamily) {
        self.fetchCustomFamily(name: family.boldFont, font: &boldFont)
        self.fetchCustomFamily(name: family.regularFont, font: &regularFont)
        self.fetchCustomFamily(name: family.lightFont, font: &lightFont)
    }

    private func fetchCustomFamily(name: String, font: inout UIFont) {
        guard name.isEmpty == false else {
            return
        }
        
        guard let fontWithName = UIFont(name: name, size: bodySize) else {
            print("Could not load font with name \(name)")
            return
        }

        font = fontWithName
    }
    
    func getBoldFont(withSize size: CGFloat? = nil) -> UIFont {
        return size != nil ? boldFont.withSize(size!) : boldFont
    }
    
    func getRegularFont(withSize size: CGFloat? = nil) -> UIFont {
        return size != nil ? regularFont.withSize(size!) : regularFont
    }
    
    func headerBold() -> UIFont {
        return boldFont.withSize(headerSize)
    }
    
    func headerRegular() -> UIFont {
        return regularFont.withSize(headerSize)
    }
    
    func bodyRegular() -> UIFont {
        return regularFont.withSize(bodySize)
    }

    func bodyBold() -> UIFont {
        return boldFont.withSize(bodySize)
    }

    func captionRegular() -> UIFont {
        return regularFont.withSize(captionSize)
    }

    func captionBold() -> UIFont {
        return boldFont.withSize(captionSize)
    }

    func footnoteRegular() -> UIFont {
        return regularFont.withSize(footnoteSize)
    }

    func footnoteBold() -> UIFont {
        return boldFont.withSize(footnoteSize)
    }

    func titleRegular() -> UIFont {
        return regularFont.withSize(titleSize)
    }

    func titleBold() -> UIFont {
        return boldFont.withSize(titleSize)
    }

    func subtitleRegular() -> UIFont {
        return regularFont.withSize(subtitleSize)
    }

    func subtitleBold() -> UIFont {
        return boldFont.withSize(subtitleSize)
    }
}

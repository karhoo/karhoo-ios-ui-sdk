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
    let italicFont: String
    
    public init(boldFont: String = "",
                regularFont: String = "",
                lightFont: String = "",
                italicFont: String = "") {
        self.boldFont = boldFont
        self.regularFont = regularFont
        self.lightFont = lightFont
        self.italicFont = italicFont
    }
}

struct KarhooFonts {

    private let titleSize: CGFloat = 30
    private let fontSize24: CGFloat = 24
    private let subtitleSize: CGFloat = 20
    private let headerSize: CGFloat = 17
    private let bodySize: CGFloat = 15
    private let captionSize: CGFloat = 12
    private let footnoteSize: CGFloat = 10
    
    private var boldFont: UIFont = UIFont.systemFont(ofSize: 0, weight: .bold)
    private var semiboldFont: UIFont = .systemFont(ofSize: 0, weight: .semibold)
    private var regularFont: UIFont = UIFont.systemFont(ofSize: 0, weight: .regular)
    private var lightFont: UIFont = UIFont.systemFont(ofSize: 0, weight: .light)
    private var italicFont: UIFont = UIFont(descriptor: UIFont.systemFont(ofSize: 0, weight: .regular).fontDescriptor.withSymbolicTraits(.traitItalic)!, size: 0)

    init(family: FontFamily) {
        self.fetchCustomFamily(name: family.boldFont, font: &boldFont)
        self.fetchCustomFamily(name: family.regularFont, font: &regularFont)
        self.fetchCustomFamily(name: family.lightFont, font: &lightFont)
        self.fetchCustomFamily(name: family.italicFont, font: &italicFont)
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
        size != nil ? boldFont.withSize(size!) : boldFont
    }

    func getSemiboldFont(withSize size: CGFloat? = nil) -> UIFont {
        size != nil ? semiboldFont.withSize(size!) : semiboldFont
    }
    
    func getRegularFont(withSize size: CGFloat? = nil) -> UIFont {
        size != nil ? regularFont.withSize(size!) : regularFont
    }
    
    func getItalicFont(withSize size: CGFloat? = nil) -> UIFont {
        size != nil ? italicFont.withSize(size!) : italicFont
    }
    
    func headerBold() -> UIFont {
        boldFont.withSize(headerSize)
    }

    func headerSemibold() -> UIFont {
        semiboldFont.withSize(headerSize)
    }
    
    func headerRegular() -> UIFont {
        regularFont.withSize(headerSize)
    }
    
    func headerItalic() -> UIFont {
        italicFont.withSize(headerSize)
    }
    
    func bodyRegular() -> UIFont {
        regularFont.withSize(bodySize)
    }

    func bodySemibold() -> UIFont {
        return semiboldFont.withSize(bodySize)
    }

    func bodyBold() -> UIFont {
        boldFont.withSize(bodySize)
    }
    
    func bodyItalic() -> UIFont {
        italicFont.withSize(bodySize)
    }

    func captionRegular() -> UIFont {
        regularFont.withSize(captionSize)
    }

    func captionSemibold() -> UIFont {
        semiboldFont.withSize(captionSize)
    }

    func captionBold() -> UIFont {
        boldFont.withSize(captionSize)
    }
    
    func captionItalic() -> UIFont {
        italicFont.withSize(captionSize)
    }

    func footnoteRegular() -> UIFont {
        regularFont.withSize(footnoteSize)
    }

    func footnoteBold() -> UIFont {
        boldFont.withSize(footnoteSize)
    }
    
    func footnoteSemiold() -> UIFont {
        semiboldFont.withSize(footnoteSize)
    }
    
    func footnoteItalic() -> UIFont {
        italicFont.withSize(footnoteSize)
    }

    func titleRegular() -> UIFont {
        regularFont.withSize(titleSize)
    }

    func titleBold() -> UIFont {
        boldFont.withSize(titleSize)
    }
    
    func titleItalic() -> UIFont {
        italicFont.withSize(titleSize)
    }
    
    func title2Regular() -> UIFont {
        regularFont.withSize(fontSize24)
    }

    func title2Bold() -> UIFont {
        boldFont.withSize(fontSize24)
    }
    
    func title2Italic() -> UIFont {
        italicFont.withSize(fontSize24)
    }

    func subtitleRegular() -> UIFont {
        regularFont.withSize(subtitleSize)
    }

    func subtitleSemibold() -> UIFont {
        semiboldFont.withSize(subtitleSize)
    }

    func subtitleBold() -> UIFont {
        boldFont.withSize(subtitleSize)
    }
    
    func subtitleItalic() -> UIFont {
        italicFont.withSize(subtitleSize)
    }
}

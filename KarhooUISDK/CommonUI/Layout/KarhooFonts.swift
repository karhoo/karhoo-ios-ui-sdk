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
    private let subtitleSize: CGFloat = 20
    private let fontSize24: CGFloat = 24
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
        return size != nil ? boldFont.withSize(size!) : boldFont
    }

    func getSemiboldFont(withSize size: CGFloat? = nil) -> UIFont {
        size != nil ? semiboldFont.withSize(size!) : semiboldFont
    }
    
    func getRegularFont(withSize size: CGFloat? = nil) -> UIFont {
        return size != nil ? regularFont.withSize(size!) : regularFont
    }
    
    func getItalicFont(withSize size: CGFloat? = nil) -> UIFont {
        return size != nil ? italicFont.withSize(size!) : italicFont
    }
    
    func headerBold() -> UIFont {
        return boldFont.withSize(headerSize)
    }
    
    func headerRegular() -> UIFont {
        return regularFont.withSize(headerSize)
    }
    
    func headerItalic() -> UIFont {
        return italicFont.withSize(headerSize)
    }
    
    func bodyRegular() -> UIFont {
        return regularFont.withSize(bodySize)
    }

    func bodyBold() -> UIFont {
        return boldFont.withSize(bodySize)
    }
    
    func bodyItalic() -> UIFont {
        return italicFont.withSize(bodySize)
    }

    func captionRegular() -> UIFont {
        return regularFont.withSize(captionSize)
    }

    func captionBold() -> UIFont {
        return boldFont.withSize(captionSize)
    }
    
    func captionItalic() -> UIFont {
        return italicFont.withSize(captionSize)
    }

    func footnoteRegular() -> UIFont {
        return regularFont.withSize(footnoteSize)
    }

    func footnoteBold() -> UIFont {
        return boldFont.withSize(footnoteSize)
    }
    
    func footnoteItalic() -> UIFont {
        return italicFont.withSize(footnoteSize)
    }

    func titleRegular() -> UIFont {
        return regularFont.withSize(titleSize)
    }

    func titleBold() -> UIFont {
        return boldFont.withSize(titleSize)
    }
    
    func titleItalic() -> UIFont {
        return italicFont.withSize(titleSize)
    }

    func subtitleRegular() -> UIFont {
        return regularFont.withSize(subtitleSize)
    }

    func subtitleBold() -> UIFont {
        return boldFont.withSize(subtitleSize)
    }
    
    func subtitleItalic() -> UIFont {
        return italicFont.withSize(subtitleSize)
    }
}

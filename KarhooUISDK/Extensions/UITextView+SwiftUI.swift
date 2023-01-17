//
//  UITextView+SwiftUI.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//
// swiftlint:disable all


import SwiftUI
import UIKit

/**
The `UITextView` bridging to SwiftUI used due to inability to use `NSAttributedString` with current (iOS 14) deployment targer. Once DT is bump to iOS 15 the TextView should be removed and usage of NSAttributedString should be replaced with brand new `AttributedString`.
 */
struct TextView: View {

    @Environment(\.layoutDirection) private var layoutDirection

    @Binding private var text: NSAttributedString
    @Binding private var isEmpty: Bool

    @State private var calculatedHeight: CGFloat = 44

    private var onEditingChanged: (() -> Void)?
    private var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?
    private var onCommit: (() -> Void)?

    var placeholderView: AnyView?
    var foregroundColor: UIColor = .label
    var autocapitalization: UITextAutocapitalizationType = .sentences
    var multilineTextAlignment: TextAlignment = .leading
    var font: UIFont = .preferredFont(forTextStyle: .body)
    var returnKeyType: UIReturnKeyType?
    var clearsOnInsertion: Bool = false
    var autocorrection: UITextAutocorrectionType = .default
    var truncationMode: NSLineBreakMode = .byTruncatingTail
    var isEditable: Bool = true
    var isSelectable: Bool = true
    var isScrollingEnabled: Bool = false
    var enablesReturnKeyAutomatically: Bool?
    var autoDetectionTypes: UIDataDetectorTypes = []
    var allowRichText: Bool

    /// Makes a new TextView with the specified configuration
    /// - Parameters:
    ///   - text: A binding to the text
    ///   - shouldEditInRange: A closure that's called before an edit it applied, allowing the consumer to prevent the change
    ///   - onEditingChanged: A closure that's called after an edit has been applied
    ///   - onCommit: If this is provided, the field will automatically lose focus when the return key is pressed
    init(
        _ text: Binding<String>,
        shouldEditInRange: ((Range<String.Index>, String) -> Bool)? = nil,
        onEditingChanged: (() -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        _text = Binding(
            get: { NSAttributedString(string: text.wrappedValue) },
            set: { text.wrappedValue = $0.string }
        )

        _isEmpty = Binding(
            get: { text.wrappedValue.isEmpty },
            set: { _ in }
        )

        self.onCommit = onCommit
        self.shouldEditInRange = shouldEditInRange
        self.onEditingChanged = onEditingChanged

        allowRichText = false
    }

    /// Makes a new TextView that supports `NSAttributedString`
    /// - Parameters:
    ///   - text: A binding to the attributed text
    ///   - onEditingChanged: A closure that's called after an edit has been applied
    ///   - onCommit: If this is provided, the field will automatically lose focus when the return key is pressed
    init(
        _ text: Binding<NSAttributedString>,
        onEditingChanged: (() -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        _text = text
        _isEmpty = Binding(
            get: { text.wrappedValue.string.isEmpty },
            set: { _ in }
        )

        self.onCommit = onCommit
        self.onEditingChanged = onEditingChanged

        allowRichText = true
    }

    var body: some View {
        Representable(
            text: $text,
            calculatedHeight: $calculatedHeight,
            foregroundColor: foregroundColor,
            autocapitalization: autocapitalization,
            multilineTextAlignment: multilineTextAlignment,
            returnKeyType: returnKeyType,
            clearsOnInsertion: clearsOnInsertion,
            autocorrection: autocorrection,
            truncationMode: truncationMode,
            isEditable: isEditable,
            isSelectable: isSelectable,
            isScrollingEnabled: isScrollingEnabled,
            enablesReturnKeyAutomatically: enablesReturnKeyAutomatically,
            autoDetectionTypes: autoDetectionTypes,
            allowsRichText: allowRichText,
            onEditingChanged: onEditingChanged,
            shouldEditInRange: shouldEditInRange,
            onCommit: onCommit
        )
        .frame(
            minHeight: isScrollingEnabled ? 0 : calculatedHeight,
            maxHeight: isScrollingEnabled ? .infinity : calculatedHeight
        )
        .background(
            placeholderView?
                .foregroundColor(Color(.placeholderText))
                .multilineTextAlignment(multilineTextAlignment)
                .font(Font(font))
                .padding(.horizontal, isScrollingEnabled ? 5 : 0)
                .padding(.vertical, isScrollingEnabled ? 8 : 0)
                .opacity(isEmpty ? 1 : 0),
            alignment: .topLeading
        )
    }

}

private final class UIKitTextView: UITextView {

    override var keyCommands: [UIKeyCommand]? {
        return (super.keyCommands ?? []) + [
            UIKeyCommand(input: UIKeyCommand.inputEscape, modifierFlags: [], action: #selector(escape(_:)))
        ]
    }

    @objc private func escape(_ sender: Any) {
        resignFirstResponder()
    }

}

private struct RoundedTextView: View {
    @State private var text: NSAttributedString = .init()

    var body: some View {
        VStack(alignment: .leading) {
            TextView($text)
                .padding(.leading, 25)

            GeometryReader { _ in
                TextView($text)
                    .placeholder("Enter some text")
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color(.placeholderText))
                    )
                    .padding()
            }
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))

            Button {
                text = NSAttributedString(string: "This is interesting", attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .headline)
                ])
            } label: {
                Spacer()
                Text("Interesting?")
                Spacer()
            }
            .padding()
        }
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedTextView()
    }
}

private extension TextView.Representable {
    final class Coordinator: NSObject, UITextViewDelegate {

        internal let textView: UIKitTextView

        private var originalText: NSAttributedString = .init()
        private var text: Binding<NSAttributedString>
        private var calculatedHeight: Binding<CGFloat>

        var onCommit: (() -> Void)?
        var onEditingChanged: (() -> Void)?
        var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?

        init(
            text: Binding<NSAttributedString>,
            calculatedHeight: Binding<CGFloat>,
            shouldEditInRange: ((Range<String.Index>, String) -> Bool)?,
            onEditingChanged: (() -> Void)?,
            onCommit: (() -> Void)?
        ) {
            textView = UIKitTextView()
            textView.backgroundColor = .clear
            textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

            self.text = text
            self.calculatedHeight = calculatedHeight
            self.shouldEditInRange = shouldEditInRange
            self.onEditingChanged = onEditingChanged
            self.onCommit = onCommit

            super.init()
            textView.delegate = self
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            originalText = text.wrappedValue
        }

        func textViewDidChange(_ textView: UITextView) {
            text.wrappedValue = NSAttributedString(attributedString: textView.attributedText)
            recalculateHeight()
            onEditingChanged?()
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if onCommit != nil, text == "\n" {
                onCommit?()
                originalText = NSAttributedString(attributedString: textView.attributedText)
                textView.resignFirstResponder()
                return false
            }

            return true
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            // this check is to ensure we always commit text when we're not using a closure
            if onCommit != nil {
                text.wrappedValue = originalText
            }
        }

    }

}

private extension TextView.Representable.Coordinator {

    func update(representable: TextView.Representable) {
        textView.attributedText = representable.text
        textView.adjustsFontForContentSizeCategory = true
        textView.textColor = representable.foregroundColor
        textView.autocapitalizationType = representable.autocapitalization
        textView.autocorrectionType = representable.autocorrection
        textView.isEditable = representable.isEditable
        textView.isSelectable = representable.isSelectable
        textView.isScrollEnabled = representable.isScrollingEnabled
        textView.dataDetectorTypes = representable.autoDetectionTypes
        textView.allowsEditingTextAttributes = representable.allowsRichText

        switch representable.multilineTextAlignment {
        case .leading:
            textView.textAlignment = textView.traitCollection.layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            textView.textAlignment = textView.traitCollection.layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            textView.textAlignment = .center
        }

        if let value = representable.enablesReturnKeyAutomatically {
            textView.enablesReturnKeyAutomatically = value
        } else {
            textView.enablesReturnKeyAutomatically = onCommit == nil ? false : true
        }

        if let returnKeyType = representable.returnKeyType {
            textView.returnKeyType = returnKeyType
        } else {
            textView.returnKeyType = onCommit == nil ? .default : .done
        }

        if !representable.isScrollingEnabled {
            textView.textContainer.lineFragmentPadding = 0
            textView.textContainerInset = .zero
        }

        recalculateHeight()
        textView.setNeedsDisplay()
    }

    private func recalculateHeight() {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
        guard calculatedHeight.wrappedValue != newSize.height else { return }

        DispatchQueue.main.async { // call in next render cycle.
            self.calculatedHeight.wrappedValue = newSize.height
        }
    }
}

extension TextView {

    /// Specifies whether or not this view allows rich text
    /// - Parameter enabled: If `true`, rich text editing controls will be enabled for the user
    func allowsRichText(_ enabled: Bool) -> TextView {
        var view = self
        view.allowRichText = enabled
        return view
    }

    /// Specify a placeholder text
    /// - Parameter placeholder: The placeholder text
    func placeholder(_ placeholder: String) -> TextView {
        self.placeholder(placeholder) { $0 }
    }

    /// Specify a placeholder with the specified configuration
    ///
    /// Example:
    ///
    ///     TextView($text)
    ///         .placeholder("placeholder") { view in
    ///             view.foregroundColor(.red)
    ///         }
    func placeholder<V: View>(_ placeholder: String, _ configure: (Text) -> V) -> TextView {
        var view = self
        let text = Text(placeholder)
        view.placeholderView = AnyView(configure(text))
        return view
    }

    /// Specify a custom placeholder view
    func placeholder<V: View>(_ placeholder: V) -> TextView {
        var view = self
        view.placeholderView = AnyView(placeholder)
        return view
    }

    /// Enables auto detection for the specified types
    /// - Parameter types: The types to detect
    func autoDetectDataTypes(_ types: UIDataDetectorTypes) -> TextView {
        var view = self
        view.autoDetectionTypes = types
        return view
    }

    /// Specify the foreground color for the text
    /// - Parameter color: The foreground color
    func foregroundColor(_ color: UIColor) -> TextView {
        var view = self
        view.foregroundColor = color
        return view
    }

    /// Specifies the capitalization style to apply to the text
    /// - Parameter style: The capitalization style
    func autocapitalization(_ style: UITextAutocapitalizationType) -> TextView {
        var view = self
        view.autocapitalization = style
        return view
    }

    /// Specifies the alignment of multi-line text
    /// - Parameter alignment: The text alignment
    func multilineTextAlignment(_ alignment: TextAlignment) -> TextView {
        var view = self
        view.multilineTextAlignment = alignment
        return view
    }

    /// Specifies the font to apply to the text
    /// - Parameter font: The font to apply
    func font(_ font: UIFont) -> TextView {
        var view = self
        view.font = font
        return view
    }

    /// Specifies the font weight to apply to the text
    /// - Parameter weight: The font weight to apply
    func fontWeight(_ weight: UIFont.Weight) -> TextView {
        font(font.weight(weight))
    }

    /// Specifies if the field should clear its content when editing begins
    /// - Parameter value: If true, the field will be cleared when it receives focus
    func clearOnInsertion(_ value: Bool) -> TextView {
        var view = self
        view.clearsOnInsertion = value
        return view
    }

    /// Disables auto-correct
    /// - Parameter disable: If true, autocorrection will be disabled
    func disableAutocorrection(_ disable: Bool?) -> TextView {
        var view = self
        if let disable = disable {
            view.autocorrection = disable ? .no : .yes
        } else {
            view.autocorrection = .default
        }
        return view
    }

    /// Specifies whether the text can be edited
    /// - Parameter isEditable: If true, the text can be edited via the user's keyboard
    func isEditable(_ isEditable: Bool) -> TextView {
        var view = self
        view.isEditable = isEditable
        return view
    }

    /// Specifies whether the text can be selected
    /// - Parameter isSelectable: If true, the text can be selected
    func isSelectable(_ isSelectable: Bool) -> TextView {
        var view = self
        view.isSelectable = isSelectable
        return view
    }

    /// Specifies whether the field can be scrolled. If true, auto-sizing will be disabled
    /// - Parameter isScrollingEnabled: If true, scrolling will be enabled
    func enableScrolling(_ isScrollingEnabled: Bool) -> TextView {
        var view = self
        view.isScrollingEnabled = isScrollingEnabled
        return view
    }

    /// Specifies the type of return key to be shown during editing, for the device keyboard
    /// - Parameter style: The return key style
    func returnKey(_ style: UIReturnKeyType?) -> TextView {
        var view = self
        view.returnKeyType = style
        return view
    }

    /// Specifies whether the return key should auto enable/disable based on the current text
    /// - Parameter value: If true, when the text is empty the return key will be disabled
    func automaticallyEnablesReturn(_ value: Bool?) -> TextView {
        var view = self
        view.enablesReturnKeyAutomatically = value
        return view
    }

    /// Specifies the truncation mode for this field
    /// - Parameter mode: The truncation mode
    func truncationMode(_ mode: Text.TruncationMode) -> TextView {
        var view = self
        switch mode {
        case .head: view.truncationMode = .byTruncatingHead
        case .tail: view.truncationMode = .byTruncatingTail
        case .middle: view.truncationMode = .byTruncatingMiddle
        @unknown default:
            fatalError("Unknown text truncation mode")
        }
        return view
    }

}

private extension TextView {
    struct Representable: UIViewRepresentable {

        @Binding var text: NSAttributedString
        @Binding var calculatedHeight: CGFloat

        let foregroundColor: UIColor
        let autocapitalization: UITextAutocapitalizationType
        var multilineTextAlignment: TextAlignment
        let returnKeyType: UIReturnKeyType?
        let clearsOnInsertion: Bool
        let autocorrection: UITextAutocorrectionType
        let truncationMode: NSLineBreakMode
        let isEditable: Bool
        let isSelectable: Bool
        let isScrollingEnabled: Bool
        let enablesReturnKeyAutomatically: Bool?
        var autoDetectionTypes: UIDataDetectorTypes = []
        var allowsRichText: Bool

        var onEditingChanged: (() -> Void)?
        var shouldEditInRange: ((Range<String.Index>, String) -> Bool)?
        var onCommit: (() -> Void)?

        func makeUIView(context: Context) -> UIKitTextView {
            context.coordinator.textView
        }

        func updateUIView(_ view: UIKitTextView, context: Context) {
            context.coordinator.update(representable: self)
        }

        @discardableResult func makeCoordinator() -> Coordinator {
            Coordinator(
                text: $text,
                calculatedHeight: $calculatedHeight,
                shouldEditInRange: shouldEditInRange,
                onEditingChanged: onEditingChanged,
                onCommit: onCommit
            )
        }

    }

}

private extension UIFont {
    static var caption2: UIFont = .preferredFont(forTextStyle: .caption2)
    static var caption: UIFont = .preferredFont(forTextStyle: .caption1)
    static var footnote: UIFont = .preferredFont(forTextStyle: .footnote)
    static var callout: UIFont = .preferredFont(forTextStyle: .callout)
    static var body: UIFont = .preferredFont(forTextStyle: .body)
    static var subheadline: UIFont = .preferredFont(forTextStyle: .subheadline)
    static var headline: UIFont = .preferredFont(forTextStyle: .headline)
    static var title3: UIFont = .preferredFont(forTextStyle: .title3)
    static var title2: UIFont = .preferredFont(forTextStyle: .title2)
    static var title: UIFont = .preferredFont(forTextStyle: .title1)
    static var largeTitle: UIFont = .preferredFont(forTextStyle: .largeTitle)
}

private extension UIFont {

    enum Leading {
        case loose
        case tight
    }

    private func addingAttributes(_ attributes: [UIFontDescriptor.AttributeName: Any]) -> UIFont {
        return UIFont(descriptor: fontDescriptor.addingAttributes(attributes), size: pointSize)
    }

    static func system(size: CGFloat, weight: UIFont.Weight, design: UIFontDescriptor.SystemDesign = .default) -> UIFont {
        let descriptor = UIFont.systemFont(ofSize: size).fontDescriptor
            .addingAttributes([
                UIFontDescriptor.AttributeName.traits: [
                    UIFontDescriptor.TraitKey.weight: weight.rawValue
                ]
            ]).withDesign(design)!
        return UIFont(descriptor: descriptor, size: size)
    }

    static func system(_ style: UIFont.TextStyle, design: UIFontDescriptor.SystemDesign = .default) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).withDesign(design)!
        return UIFont(descriptor: descriptor, size: 0)
    }

    func weight(_ weight: UIFont.Weight) -> UIFont {
        return addingAttributes([
            UIFontDescriptor.AttributeName.traits: [
                UIFontDescriptor.TraitKey.weight: weight.rawValue
            ]
        ])
    }

    func italic() -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(.traitItalic)!
        return UIFont(descriptor: descriptor, size: 0)
    }

    func bold() -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(.traitBold)!
        return UIFont(descriptor: descriptor, size: 0)
    }

    func leading(_ leading: Leading) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(leading == .loose ? .traitLooseLeading : .traitTightLeading)!
        return UIFont(descriptor: descriptor, size: 0)
    }

    func smallCaps() -> UIFont {
        return addingAttributes([
            .featureSettings: [
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector
                ],
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kUpperCaseType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseSmallCapsSelector
                ]
            ]
        ])
    }

    func lowercaseSmallCaps() -> UIFont {
        return addingAttributes([
            .featureSettings: [
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector
                ]
            ]
        ])
    }

    func uppercaseSmallCaps() -> UIFont {
        return addingAttributes([
            .featureSettings: [
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kUpperCaseType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kUpperCaseSmallCapsSelector
                ]
            ]
        ])
    }

    func monospacedDigit() -> UIFont {
        return addingAttributes([
            .featureSettings: [
                [
                    UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                    UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
                ]
            ]
        ])
    }
}

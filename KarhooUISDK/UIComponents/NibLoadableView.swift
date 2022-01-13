//
//  NibLoadableView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public class NibLoadableView: UIView {
    private var nibView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        guard nibView == nil else {
            return
        }

        let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!

        var bundle = Bundle(for: type(of: self))
        if NSClassFromString("XCTest") != nil {
            bundle.path(forResource: nibName, ofType: "nib")
        } else {
            bundle = Bundle.current
        }

        let views = bundle.loadNibNamed(nibName, owner: self, options: nil)

        nibView = views?.first as? UIView
        guard nibView != nil else {
            return
        }

        addSubview(nibView)
        Constraints.pinEdges(of: nibView, to: self)
    }
}

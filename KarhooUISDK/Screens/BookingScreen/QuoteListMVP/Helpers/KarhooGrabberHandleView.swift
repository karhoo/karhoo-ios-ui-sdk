//
//  KarhooGrabberHandleView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

//final class KarhooGrabberHandleView: UIView {
//    public struct Default {
//        public static let width: CGFloat = 36.0
//        public static let height: CGFloat = 5.0
//        public static let barColor = UIColor(displayP3Red: 0.76, green: 0.77, blue: 0.76, alpha: 1.0)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        render()
//    }
//
//    init() {
//        let size = CGSize(width: Default.width,
//                          height: Default.height)
//        super.init(frame: CGRect(origin: .zero, size: size))
//        self.backgroundColor = Default.barColor
//        render()
//    }
//
//    private func render() {
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = frame.size.height * 0.5
//    }
//
//    // create larger tappable area
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        let expandedBounds = self.bounds.insetBy(dx: -20, dy: -10)
//        return expandedBounds.contains(point)
//    }
//}

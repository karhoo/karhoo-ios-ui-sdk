//
//  UIConstants.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 05.01.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//
// swiftlint:disable nesting

import Foundation
import UIKit

// Note: When updating the UI, aproximate the commented values to the ones before each comment. 
// E.g.: replace any spacing of value 17 with .standard (which is 16)
public struct UIConstants {
    public struct Spacing {
        /// 1
        public static let xxxSmall: CGFloat = 1
        
        /// 2
        public static let xxSmall: CGFloat = 2
        
        /// 4
        public static let xSmall: CGFloat = 4 // 3...5
        
        /// 8
        public static let small: CGFloat = 8 // 6...10
        
        /// 12
        public static let medium: CGFloat = 12 // 11...14
        
        /// 16
        public static let standard: CGFloat = 16 // 15...21
        
        /// 24
        public static let large: CGFloat = 24 // 22...28
        
        /// 32
        public static let xLarge: CGFloat = 32 // 29...40
        
        /// 44
        public static let xxLarge: CGFloat = 44 // 41...56
        
        /// 64
        public static let xxxLarge: CGFloat = 64 // 57+
        
        /// 20
        public static let marginToEdgeOfScreen: CGFloat = 20
    }
    
    public struct Dimension {
        public struct Button {
            /// 24
            public static let small: CGFloat = 24

            /// 32
            public static let medium: CGFloat = 32

            /// 44
            public static let standard: CGFloat = 44
            
            /// 55
            public static let large: CGFloat = 55
            
            /// 64
            public static let xlarge: CGFloat = 64
            
            /// 128
            public static let xxLarge: CGFloat = 128

            /// 48
            public static let mainActionButtonHeight: CGFloat = 48
        }
        
        public struct Icon {
            /// 11
            public static let small: CGFloat = 11 // 8...14
            
            /// 16
            public static let medium: CGFloat = 16 // 15...17
            
            /// 22
            public static let standard: CGFloat = 22 // 18...26
            
            /// 32
            public static let large: CGFloat = 32 // 27...39
            
            /// 44
            public static let xLarge: CGFloat = 44 // 44...53
            
            /// 64
            public static let xxLarge: CGFloat = 64 // 54+

            /// 120
            public static let xxxLarge: CGFloat = 120

            /// 222
            public static let logoWidth: CGFloat = 222
        }
        
        public struct Separator {
            /// 1
            public static let height: CGFloat = 1 // 0.5...2
            
            /// 3
            public static let largeHeight: CGFloat = 3
           
        }
        
        public struct Border {
            /// 0
            public static let noBorder: CGFloat = 0
            
            /// 0.5
            public static let mediumWidth: CGFloat = 0.5
            
            /// 1
            public static let standardWidth: CGFloat = 1
            
            /// 1.25
            public static let largeWidth: CGFloat = 1.25

            /// 2
            public static let xLargeWidth: CGFloat = 2
        }
        
        public struct SafeArea {
            public static var bottomHeight: CGFloat {
                let window = UIApplication.shared.windows.first
                return window?.safeAreaInsets.bottom ?? 20
            }
            public static var topHeight: CGFloat {
                let window = UIApplication.shared.windows.first
                return window?.safeAreaInsets.top ?? 20
            }
        }
        
        public struct View {
            /// 4
            public static let tabSelectionIndicatorHeight: CGFloat = 4

            /// 4
            public static let loadingBarHeight: CGFloat = 4
            
            /// 22 x 22
            public static let loadingHudSize = CGSize(width: 22.0, height: 22.0)
            
            /// 200
            public static let loadingViewHeight: CGFloat = 200 // KarhooQuoteListViewController > loadingView
            
            /// 90
            public static let headerHeight: CGFloat = 90
            
            /// 50
            public static let rowHeight: CGFloat = 50 // includes KarhooQuoteListViewController > prebookQuotesTitleLabel height
            
            /// 60
            public static let largeRowHeight: CGFloat = 60 // includes the address search bar height
            
            /// 20
            public static let tagHeight: CGFloat = 20
            
            /// 30
            public static let largeTagHeight: CGFloat = 30
            
            /// 30
            public static let smallRowHeight: CGFloat = 30
            
            /// 280
            public static let sideMenuWidth: CGFloat = 280
            
            // TODO: think of better names
            /// 212 x 212
            public static let findTripSpinnerSize = CGSize(width: 212, height: 212)
            
            /// 150
            public static let fleetAvailabilityHeight: CGFloat = 150 // KarhooBookingViewController > bottomNotificationViewBottomConstraint
            
            /// 230
            public static let quoteListHeight: CGFloat = 230 // QuoteListPanelLayout
            
            /// 140
            public static let quoteListTopOffset: CGFloat = 140 // QuoteListPanelLayout
            
            /// 162
            public static let cancelTripProgressViewWidth: CGFloat = 162 // KarhooCancelButtonView
            
            /// 180 x 180
            public static let driverDetailsViewSize = CGSize(width: 180, height: 180)

            /// 95%
            public static let mainActionButtonPressedAffineTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)

            static let routeOnMapEdgeInsets = UIEdgeInsets(top: 150, left: 50, bottom: 50, right: 50)
        }
    }
    
    public struct CornerRadius {
        /// 2
        public static let xSmall: CGFloat = 2

        /// 4
        public static let small: CGFloat = 4 // 3...5
        
        /// 8
        public static let medium: CGFloat = 8
        
        /// 10
        public static let large: CGFloat = 10

        /// 12
        public static let xLarge: CGFloat = 12
        
        /// 16
        public static let xxLarge: CGFloat = 16
        
        /// 20
        public static let xxxLarge: CGFloat = 20
    }
    
    public struct ShadowRadius {
        /// 0.5
        public static let border: CGFloat = 0.5
    }
    
    // Animation duration
    public struct Duration {
        /// 0.1
        public static let xShort: Double = 0.1
        
        /// 0.2
        public static let short: Double = 0.2
        
        /// 0.3
        public static let medium: Double = 0.3
        
        /// 0.45
        public static let long: Double = 0.45
        
        /// 0.5
        public static let xLong: Double = 0.5
        
        /// 0.1
        public static let xxSmallDelay: Double = 0.1
        
        /// 0.25
        public static let xSmallDelay: Double = 0.25
        
        /// 0.3
        public static let smallDelay: Double = 0.3
        
        /// 3
        public static let xxLongDelay: Double = 3
        
        /// 4
        public static let xxxLongDelay: Double = 4
    }
    
    public struct Alpha {
        /// 0
        public static let hidden: CGFloat = 0
        
        /// 1
        public static let enabled: CGFloat = 1
        
        /// 0.4
        public static let disabled: CGFloat = 0.4
        
        /// 0.5
        public static let shadow: CGFloat = 0.5

        static let lightShadow: CGFloat = 0.2
        
        /// 0.6
        public static let overlay: CGFloat = 0.6
    }

    struct Animation {
        /// 0.5
        static let springWithDamping: CGFloat = 0.5

        /// 0.8
        static let initialSpringVelocity: CGFloat = 0.8
    }

    enum Shadow {
        static let smallRadius: CGFloat = 1.5
        
        static let lightShadowAlpha: CGFloat = 0.2

        static let shadowAlpha: CGFloat = 0.5
    }
}

// swiftlint:enable nesting

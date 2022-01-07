//
//  UIDimens.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 05.01.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

// Note: When updating the UI, aproximate the commented values to the ones before each comment. E.g.: replace any spacing of value 17 with .standard (which is 16)
public struct UIDimens {
    public struct Spacing {
        public static let xxxSmall: CGFloat = 1
        public static let xxSmall: CGFloat = 2
        public static let xSmall: CGFloat = 4 //3...5
        public static let small: CGFloat = 8 //6...10
        public static let medium: CGFloat = 12 //11...14
        public static let standard: CGFloat = 16 //15...21
        public static let large: CGFloat = 24 //22...28
        public static let xLarge: CGFloat = 32 //29...40
        public static let xxLarge: CGFloat = 44 //41...56
        public static let xxxLarge: CGFloat = 64 // 57+
        public static let marginToEdgeOfScreen: CGFloat = 20
    }
    
    public struct Size {
        public struct Button {
            public static let small: CGFloat = 24
            public static let standard: CGFloat = 44
            public static let large: CGFloat = 55 //e.g.: the Book button in the checkout screen
            public static let xlarge: CGFloat = 64
            public static let xxLarge: CGFloat = 128
        }
        
        public struct Icon {
            public static let small: CGFloat = 11 //8...14
            public static let medium: CGFloat = 16 //15...17
            public static let standard: CGFloat = 22 //18...26
            public static let large: CGFloat = 32 //27...39
            public static let xLarge: CGFloat = 44 //44...53
            public static let xxLarge: CGFloat = 64 //54+
            public static let logoWidth: CGFloat = 222
        }
        
        public struct Separator {
            public static let separatorHeight: CGFloat = 1 // 0.5...2
            public static let largeSeparatorHeight: CGFloat = 3
            public static let noBorder: CGFloat = 0
            public static let mediumBorderWidth: CGFloat = 0.5
            public static let standardBorderWidth: CGFloat = 1
            public static let largeBorderWidth: CGFloat = 1.25
        }
        
        public struct SafeArea {
            public static var bottomHeight: CGFloat {
                get {
                    if #available(iOS 13.0, *) {
                        let window = UIApplication.shared.windows.first
                        return window?.safeAreaInsets.bottom ?? 20
                    } else {
                        return 20
                    }
                }
            }
            public static var topHeight: CGFloat {
                get {
                    if #available(iOS 13.0, *) {
                        let window = UIApplication.shared.windows.first
                        return window?.safeAreaInsets.top ?? 20
                    } else {
                        return 20
                    }
                }
            }
        }
        
        public struct View {
            public static let tabSelectionHeight: CGFloat = 4
            public static let loadingHudSize: CGFloat = 22
            public static let loadingViewHeight: CGFloat = 200 // KarhooQuoteListViewController > loadingView
            public static let headerHeight: CGFloat = 90
            public static let rowHeight: CGFloat = 50 //includes KarhooQuoteListViewController > prebookQuotesTitleLabel height
            public static let largeRowHeight: CGFloat = 60 // includes the address search bar height & KarhooQuoteListViewController > quoteCategoryBarView height
            public static let tagHeight: CGFloat = 20 // KarhooQuoteCategoryBarView > markerView height
            public static let sideMenuWidth: CGFloat = 280
            
            // TODO: think of better names
            public static let findTripSpinnerSize: CGFloat = 212
            public static let fleetAvailabilityHeight: CGFloat = 150 //KarhooBookingViewController > bottomNotificationViewBottomConstraint
            public static let quoteListHeight: CGFloat = 230 //QuoteListPanelLayout
            public static let quoteListTopOffset: CGFloat = 140 //QuoteListPanelLayout
            public static let cancelTripProgressViewWidth: CGFloat = 162 //KarhooCancelButtonView
            public static let driverDetailsViewSize: CGFloat = 180
        }
    }
    
    public struct CornerRadius {
        public static let small: CGFloat = 4 //3...5
        public static let medium: CGFloat = 8
        public static let large: CGFloat = 10
    }
    
    //Animation duration
    public struct Duration {
        public static let xShort: CGFloat = 0.1
        public static let short: CGFloat = 0.2
        public static let medium: CGFloat = 0.3
        public static let long: CGFloat = 0.45
        public static let xLong: CGFloat = 0.5
        
        public static let xxSmallDelay: CGFloat = 0.1
        public static let xSmallDelay: CGFloat = 0.25
        public static let smallDelay: CGFloat = 0.3
        public static let xxLongDelay: CGFloat = 3
        public static let xxxLongDelay: CGFloat = 4
    }
    
    public struct Alpha {
        public static let hidden: CGFloat = 0
        public static let enabled: CGFloat = 1
        public static let disabled: CGFloat = 0.4
        public static let shadow: CGFloat = 0.5
        public static let overlay: CGFloat = 0.6
    }
}

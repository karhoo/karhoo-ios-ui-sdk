//
//  UIDimens.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 05.01.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

// Note: When updating the UI, aproximate the commented values to the ones before each comment. E.g.: replace any spacing of value 17 to .standard (which is 16)
public struct UIDimens {
    public struct Spacing {
        public static let xxSmall: CGFloat = 2 //1
        public static let xSmall: CGFloat = 4 //3...5
        public static let small: CGFloat = 8 //6...9
        public static let medium: CGFloat = 12 //10...14
        public static let standard: CGFloat = 16 //15...20
        public static let large: CGFloat = 24 //21...28
        public static let xLarge: CGFloat = 32 //29...40
        public static let xxLarge: CGFloat = 44 //41...56
        public static let xxxLarge: CGFloat = 64 // 57+
    }
    
    public struct Size {
        public struct Button {
            public static let standard: CGFloat = 44
            public static let large: CGFloat = 64
            public static let xLarge: CGFloat = 128
        }
        
        public struct Icon {
            public static let small: CGFloat = 11 //8...14
            public static let medium: CGFloat = 16 //15...17
            public static let standard: CGFloat = 22 //18...26
            public static let large: CGFloat = 35 //27...43
        }
        
        public struct Separator {
            public static let separatorHeight: CGFloat = 1 // 0.5...2
            public static let borderWidth: CGFloat = 0.5
            public static let wideBorderWidth: CGFloat = 1.25
        }
        
        public struct SafeArea {
            public static let bottomHeight: CGFloat {
                get {
                    if #available(iOS 13.0, *) {
                        let window = UIApplication.shared.windows.first
                        return window.safeAreaInsets.bottom
                    } else {
                        return 20
                    }
                }
            }
            public static let topHeight: CGFloat {
                get {
                    if #available(iOS 13.0, *) {
                        let window = UIApplication.shared.windows.first
                        return window.safeAreaInsets.top
                    } else {
                        return 20
                    }
                }
            }
        }
        
        public struct View {
            public static let headerHeight: CGFloat = 90
            public static let rowHeight: CGFloat = 50 //includes KarhooQuoteListViewController > prebookQuotesTitleLabel height
            public static let largeRowHeight: CGFloat = 60 // includes the address search bar height & KarhooQuoteListViewController > quoteCategoryBarView height
            public static let loadingViewHeight: CGFloat = 200 // KarhooQuoteListViewController > loadingView
            public static let tagHeight: CGFloat = 20 // KarhooQuoteCategoryBarView > markerView height
            public static let spinnerSize: CGFloat = 212
            
            // TODO: think of better names
            public static let fleetAvailabilityHeight: CGFloat = 150 //KarhooBookingViewController > bottomNotificationViewBottomConstraint
            public static let quoteListHeight: CGFloat = 230 //QuoteListPanelLayout
            public static let quoteListTopOffset: CGFloat = 140 //QuoteListPanelLayout
            public static let cancelTripProgressViewWidth: CGFloat = 162 //KarhooCancelButtonView
        }
    }
    
    public struct CornerRadius {
        public static let small: CGFloat = 4 //5
        public static let medium: CGFloat = 8
        public static let large: CGFloat = 10 //try 12
    }
    
    //Animation duration
    public struct Duration {
        public static let xShort: CGFloat = 0.1
        public static let short: CGFloat = 0.2
        public static let medium: CGFloat = 0.3
        public static let long: CGFloat = 0.45
        public static let xLong: CGFloat = 0.5
        
        public static let delay: CGFloat = 0.25
        public static let mediumDelay: CGFloat = 0.3
        public static let xLongDelay: CGFloat = 3
        public static let xxLongDelay: CGFloat = 4
    }
    
    public struct Alpha {
        public static let hidden: CGFloat = 0
        public static let enabled: CGFloat = 1
        public static let disabled: CGFloat = 0.4
        public static let shadow: CGFloat = 0.5
    }
}

//
//  KarhooMailMetaInfoComposer.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

protocol MailMetaInfoComposer {
    func getMailMetaInfo() -> String
}

final class KarhooMailMetaInfoComposer: MailMetaInfoComposer {
    
    private let systemName: String = UIDevice.current.systemName
    private let systemVersion: String = UIDevice.current.systemVersion
    private let currentLocale: String = NSLocale.current.identifier
    
    func getMailMetaInfo() -> String {
        return """
                   \n \n \n
                   \(UITexts.SupportMailMessage.feedbackMailMessage)
                   ------------------
                   Application: \(getAppName()) \(getAppVersion())
                   Device: \(getPlatform())
                   System: \(systemName) \(systemVersion)
                   Locale: \(currentLocale)
                   User: \(getUserInfo())
                   ------------------
                   """
    }
    
    private func getAppName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
                    return ""
        }
        if let version: String = dictionary["CFBundleDisplayName"] as? String {
            return version
        } else {
            return ""
        }
    }
    
    private func getAppVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
                    return ""
        }
        if let version: String = dictionary["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return ""
        }
    }

    private func getPlatform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let sysInfoHardwareTypeData = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        guard let sysInfoHardwareName = String(bytes: sysInfoHardwareTypeData, encoding: .ascii) else { return "" }
        let hardwareNameWithoutControlCharacters = sysInfoHardwareName.trimmingCharacters(in: .controlCharacters)
        return hardwareNameWithoutControlCharacters
    }
    
    private func getUserInfo() -> String {
        guard let user = Karhoo.getUserService().getCurrentUser() else {
            return ""
        }
        return """
               \(UITexts.User.email): \(user.email)
               \(UITexts.User.mobilePhone): \(user.mobileNumber)
               \(UITexts.User.firstName): \(user.firstName)
               \(UITexts.User.lastName): \(user.lastName)
               """
    }
}



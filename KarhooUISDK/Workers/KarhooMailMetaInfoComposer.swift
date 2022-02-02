//
//  KarhooMailMetaInfoComposer.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 02/02/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol KarhooMailMetaInfoComposerProtocol {
    func mailMetaInfo() -> String
}

class KarhooMailMetaInfoComposer: KarhooMailMetaInfoComposerProtocol {
    func mailMetaInfo() -> String {
        let info = """
                   \n \n \n
                   \(UITexts.SupportMailMessage.feedbackMailMessage)
                   ------------------
                   Application: \(appName()) \(appVersion())
                   Device: \(platform())
                   System: \(systemName()) \(systemVersion())
                   Locale: \(currentLocale())
                   User: \(userInfo())
                   ------------------
                   """
        return info
    }
    
    private func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
                    return ""
        }
        if let version: String = dictionary["CFBundleDisplayName"] as? String {
            return version
        } else {
            return ""
        }
    }
    
    private func appVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
                    return ""
        }
        if let version: String = dictionary["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return ""
        }
    }

    private func systemName() -> String {
        return UIDevice.current.systemName
    }

    private func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }

    private func currentLocale() -> String {
        return NSLocale.current.identifier
    }

    private func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine,
                                  count: Int(_SYS_NAMELEN)),
                      encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    private func userInfo() -> String {
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



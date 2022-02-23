//  ___FILEHEADER___

import Foundation
import KarhooSDK

enum ___VARIABLE_productName:identifier___ {
    static func build() -> ___VARIABLE_productName:identifier___ViewController {
        let viewController = Karhoo___VARIABLE_productName:identifier___ViewController()
        let router = Karhoo___VARIABLE_productName:identifier___Router(viewController: viewController)
        let presenter = Karhoo___VARIABLE_productName:identifier___Presenter(router: router)

        viewController.setupBinding(presenter)

        return viewController
    }
}

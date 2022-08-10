//  ___FILEHEADER___

import Foundation
import KarhooSDK

struct Karhoo___VARIABLE_productName:identifier___Coordinator: ___VARIABLE_productName:identifier___Coordinator {
    
    var childCoordinators: [KarhooUISDKSceneCoordinator] = []
    var baseViewController: BaseViewController { viewController }
    private(set) var navigationController: UINavigationController?
    private(set) var viewController: ___VARIABLE_productName:identifier___ViewController
    private(set) var presenter: ___VARIABLE_productName:identifier___Presenter!
    
    // MARK: - Initializator
    
    init(
        navigationController: UINavigationController? = nil
    ) {
        self.navigationController = navigationController
        self.viewController = Karhoo___VARIABLE_productName:identifier___ViewController()
        self.presenter = Karhoo___VARIABLE_productName:identifier___Presenter(
            router: self
        )
        self.viewController.setupBinding(presenter)
    }
    
    func start() {
        navigationController?.show(viewController, sender: nil)
    }
}

extension Karhoo___VARIABLE_productName:identifier___Coordinator: ___VARIABLE_productName:identifier___Router {
}

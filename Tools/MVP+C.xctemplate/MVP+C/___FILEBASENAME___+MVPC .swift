//  ___FILEHEADER___

import KarhooSDK

protocol ___VARIABLE_productName:identifier___Coordinator: KarhooUISDKSceneCoordinator {
    var viewController: ___VARIABLE_productName:identifier___ViewController { get }
}

protocol ___VARIABLE_productName:identifier___ViewController: BaseViewController {
    func setupBinding(_ presenter: ___VARIABLE_productName:identifier___Presenter)
}

protocol ___VARIABLE_productName:identifier___Presenter: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
}

protocol ___VARIABLE_productName:identifier___Router: AnyObject {
}

//  ___FILEHEADER___

import UIKit
import KarhooSDK

class Karhoo___VARIABLE_productName:identifier___ViewController: UIViewController, BaseViewController, ___VARIABLE_productName:identifier___ViewController {

    // MARK: - Properties

    private var presenter: ___VARIABLE_productName:identifier___Presenter!

    // MARK: - Views
    
    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil, "Presented needs to be assinged using `setupBinding` method")
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animate: Bool) {
        super.viewWillAppear(animate)
        presenter.viewWillAppear()
    }

    // MARK: - Setup business logic

    func setupBinding(_ presenter: ___VARIABLE_productName:identifier___Presenter) {
        self.presenter = presenter
    }

    // MARK: - Setup view

    private func setupView() {
        setupProperties()
        setupHierarchy()
        setupLayout()
    }

    private func setupProperties() {
    }

    private func setupHierarchy() {
    }

    private func setupLayout() {
    }
}

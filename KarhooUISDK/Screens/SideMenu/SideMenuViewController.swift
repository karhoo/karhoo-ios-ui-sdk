//
//  SideMenuContoller.swift
//  SideMenu
//
//
//  Copyright © 2016 Yaser. All rights reserved.
//

import UIKit

final class SideMenuViewController: UIViewController, SideMenu {

    @IBOutlet private weak var contentContainer: UIView?
    @IBOutlet private weak var overlay: UIView?
    @IBOutlet private weak var menuContainer: UIView?
    @IBOutlet private weak var menuStartConstraint: NSLayoutConstraint?

    private(set) var hostViewController: UIViewController?
    private(set) var menuContentViewController: UIViewController?

    init(hostViewController: UIViewController,
         contentViewController: UIViewController) {
        self.hostViewController = hostViewController
        self.menuContentViewController = contentViewController
        super.init(nibName: "SideMenuViewController", bundle: .current)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forceLightMode()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.backgroundColor = UIColor.black

        set(child: menuContentViewController, on: menuContainer)
        set(child: hostViewController, on: contentContainer)

        hideMenu(animated: false)
    }

    func getFlowItem() -> Screen {
        return self
    }

    func showMenu() {
        view.layoutIfNeeded()

        UIView.animate(withDuration: 0.25,
                       animations: { () -> Void in
            self.menuStartConstraint?.constant = 0
            self.contentContainer?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.overlay?.alpha = 1
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func hideMenu() {
        hideMenu(animated: true)
    }

    private func set(child viewController: UIViewController?, on view: UIView?) {
        guard let view = view, let viewController = viewController else {
            return
        }

        viewController.willMove(toParent: self)
        view.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)

        Constraints.pinEdges(of: viewController.view, to: view)
    }

    private func hideMenu(animated: Bool) {
        view.layoutIfNeeded()
        let width = self.menuContainer?.frame.width ?? 0
        let animationTime = animated ? 0.25 : 0
        UIView.animate(withDuration: animationTime,
                       animations: { () -> Void in
                        self.menuStartConstraint?.constant = -width
                        self.contentContainer?.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.overlay?.alpha = 0
                        self.view.layoutIfNeeded()
        })
    }

    override var childForStatusBarStyle: UIViewController? {
        return hostViewController
    }

    public class KarhooSideMenuBuilder: SideMenuBuilder {

        func buildSideMenu(hostViewController: UIViewController,
                           routing: SideMenuHandler) -> SideMenu {

            let feedbackMailComposer = KarhooFeedbackEmailComposer()
            let sideMenuPresenter = MenuContentScreenPresenter(routing: routing,
                                                               mailConstructor: feedbackMailComposer)
            let menuContentViewController = MenuContentViewController(presenter: sideMenuPresenter)
            feedbackMailComposer.set(parent: menuContentViewController)
            sideMenuPresenter.set(view: menuContentViewController)

            return SideMenuViewController(hostViewController: hostViewController,
                                          contentViewController: menuContentViewController)
        }
    }
}

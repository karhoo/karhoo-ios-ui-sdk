//
//  MenuContentPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class MenuContentScreenPresenter: MenuContentPresenter {

    private let routing: SideMenuHandler
    private let mailConstructor: KarhooFeedbackEmailComposer?
    private weak var view: MenuContentView?

    private var unwrappedView: MenuContentView {
        
        guard let unwrappedView = self.view else {
            fatalError("Menu content view not set")
        }
        return unwrappedView
    }

    init(routing: SideMenuHandler,
         mailConstructor: KarhooFeedbackEmailComposer) {
        self.routing = routing
        self.mailConstructor = mailConstructor
    }

    func profilePressed() {
        routing.showProfile(onViewController: unwrappedView.getFlowItem())
    }

    func aboutPressed() {
        routing.showAbout(onViewController: unwrappedView.getFlowItem())
    }

    func bookingsPressed() {
        routing.showBookingsList(onViewController: unwrappedView.getFlowItem())
    }

    func helpPressed() {
        routing.showHelp(onViewController: unwrappedView.getFlowItem())
    }

    func set(view: MenuContentView) {
        self.view = view
    }
    
    func checkGuestAuthentication() {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            unwrappedView.showGuestMenu()
        }
    }
}

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
    private let mailConstructor: KarhooFeedbackEmailComposer
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
        routing.showProfile(onViewController: view!.getFlowItem())
    }

    func feedbackPressed() {
        if mailConstructor.showFeedbackMail() == false {
            aboutPressed()
        } // else: automatically opens MailComposer
    }

    func bookingsPressed() {
        routing.showBookingsList(onViewController: unwrappedView.getFlowItem())
    }

    func aboutPressed() {
        routing.showAbout(onViewController: unwrappedView.getFlowItem())
    }

    func set(view: MenuContentView) {
        self.view = view
    }
}

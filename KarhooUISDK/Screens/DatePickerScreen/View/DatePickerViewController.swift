//
//  DatePickerViewController.swift
//  Karhoo
//
//
//  Copyright (c) 2015 Karhoo Ltd. All rights reserved.
//

import UIKit

final class DatePickerViewController: UIViewController, DatePickerView {

    @IBOutlet private weak var datePickerContainerView: UIView?
    @IBOutlet private weak var backgroundView: UIView?
    @IBOutlet private weak var datePicker: UIDatePicker?
    @IBOutlet private weak var timeZoneMessage: UILabel?
    @IBOutlet private weak var pickUpLabel: UILabel!
    @IBOutlet private weak var headerLabel: UILabel!
    
    private let presenter: DatePickerPresenter

    override var preferredStatusBarStyle: UIStatusBarStyle {
        presentingViewController?.preferredStatusBarStyle ?? .lightContent
    }

    required init(presenter: DatePickerPresenter) {
        self.presenter = presenter
        super.init(nibName: "DatePickerViewController", bundle: .current)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forceLightMode()
        datePickerContainerView?.applyRoundCorners(
            [.layerMinXMinYCorner, .layerMaxXMinYCorner],
            radius: UIConstants.CornerRadius.xxLarge
        )
        headerLabel.textColor = KarhooUI.colors.text
        pickUpLabel.font = KarhooUI.fonts.headerBold()
        pickUpLabel.text = UITexts.Prebook.setPrebookTime.uppercased()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillShow()

        UIView.animate(withDuration: 0.25,
                       delay: 0.4,
                       options: .curveEaseIn,
                       animations: { [weak self] in
            self?.backgroundView?.alpha = 1.0
            }, completion: { [weak self] (_: Bool) in
                self?.presenter.viewShown()
            })
    }

    func set(date: Date) {
        datePicker?.date = date
    }

    func setDatePicker(timeZone: TimeZone) {
        datePicker?.timeZone = timeZone
    }

    func set(timeZoneMessageText: String) {
        timeZoneMessage?.text = timeZoneMessageText
    }

    func set(timeZoneMessageHidden: Bool) {
        timeZoneMessage?.isHidden = timeZoneMessageHidden
    }

    func setBoundries(min: Date, max: Date) {
        datePicker?.minimumDate = min
        datePicker?.maximumDate = max
    }
    
    func set(locale: Locale) {
        datePicker?.locale = locale
    }

    @IBAction private func dateDidChange() {
        guard let date = datePicker?.date else {
            return
        }
        presenter.dateDidChange(newDate: date)
    }

    @IBAction private func setDate() {
        self.fadeOut { [weak self] in
            self?.presenter.setDate()
        }
    }

    @IBAction private func cancel() {
        self.fadeOut { [weak self] in
            self?.presenter.cancel()
        }
    }

    private func fadeOut(completionBlock: (() -> Void)?) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn,
                       animations: {
                        self.backgroundView?.alpha = 0.0
        },
                       completion: {(_: Bool) in
                        completionBlock?()
        })
    }

    final class KarhooDatePickerScreenBuilder: DatePickerScreenBuilder {

        func buildDatePickerScreen(startDate: Date?,
                                   timeZone: TimeZone,
                                   callback: @escaping ScreenResultCallback<Date>) -> Screen {
            let presenter = KarhooDatePickerPresenter(startDate: startDate,
                                                      timeZone: timeZone,
                                                      callback: callback)
            let view = DatePickerViewController(presenter: presenter)
            presenter.set(view: view)
            return view
        }
    }
}

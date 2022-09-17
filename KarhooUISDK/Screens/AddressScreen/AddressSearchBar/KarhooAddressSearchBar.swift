//
//  AddressSearchBar.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHAddressSearchBarID {
    public static let addressbarSearchBar = "address-search-bar"
    public static let searchTextField = "search-bar-text-field"
    public static let clearButton = "clear-button"
}

class KarhooAddressSearchBar: UIView, AddressSearchBar {

    // UI Components
    private var ringIcon: UIView!
    private var searchContainer: UIView!
    private var searchTextField: UITextField!
    private var activityIndicator: UIActivityIndicatorView!
    private var clearButton: UIButton!
    
    // Logic Components
    private var presenter: AddressSearchBarPresenter?
    private var actions: AddressSearchBarActions?
    private var maxChar: Int = 0
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        accessibilityIdentifier = KHAddressSearchBarID.addressbarSearchBar
        isAccessibilityElement = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = KarhooUI.colors.white
        
        ringIcon = UIView(frame: .zero)
        ringIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ringIcon)
        
        let ringIconSize: CGFloat = 18.0
        _ = [ringIcon.widthAnchor.constraint(equalToConstant: ringIconSize),
             ringIcon.heightAnchor.constraint(equalToConstant: ringIconSize),
             ringIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
             ringIcon.topAnchor.constraint(equalTo: topAnchor, constant: 14.0),
             ringIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14.0),
             ringIcon.centerYAnchor.constraint(equalTo: centerYAnchor)].map { $0.isActive = true }
        ringIcon.layer.cornerRadius = ringIconSize / 2
        
        searchContainer = UIView()
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.accessibilityIdentifier = "search-container"
        searchContainer.layer.cornerRadius = 4
        searchContainer.backgroundColor = KarhooUI.colors.offWhite
        addSubview(searchContainer)
        
        _ = [searchContainer.topAnchor.constraint(equalTo: topAnchor, constant: 9.0),
             searchContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9.0),
             searchContainer.leadingAnchor.constraint(equalTo: ringIcon.trailingAnchor, constant: 8.0),
             searchContainer.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -17.0)].map { $0.isActive = true }
        
        searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self
        searchTextField.accessibilityIdentifier = KHAddressSearchBarID.searchTextField
        searchTextField.isAccessibilityElement = true
        searchTextField.font = UIFont.systemFont(ofSize: 14.0)
        searchTextField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        searchContainer.addSubview(searchTextField)
        
        _ = [searchTextField.heightAnchor.constraint(equalToConstant: 17.0),
             searchTextField.topAnchor.constraint(lessThanOrEqualTo: searchContainer.topAnchor, constant: 6.0),
             searchTextField.bottomAnchor.constraint(lessThanOrEqualTo: searchContainer.bottomAnchor, constant: -6.0),
             searchTextField.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor,
                                                      constant: 8.0)].map { $0.isActive = true }
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.accessibilityIdentifier = "activity-indicator"
        searchContainer.addSubview(activityIndicator)
        
        _ = [activityIndicator.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 5.0),
             activityIndicator.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
             activityIndicator.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor,
                                                        constant: 5.0)].map { $0.isActive = true }
        
        clearButton = UIButton(type: .custom)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.accessibilityIdentifier = KHAddressSearchBarID.clearButton
        clearButton.addTarget(self, action: #selector(clearPressed), for: .touchUpInside)
        clearButton.setImage(UIImage.uisdkImage("kh_search_clear"), for: .normal)
        clearButton.isHidden = true
        searchContainer.addSubview(clearButton)
        
        _ = [clearButton.widthAnchor.constraint(equalToConstant: 20.0),
             clearButton.heightAnchor.constraint(equalToConstant: 22.0),
             clearButton.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
             clearButton.leadingAnchor.constraint(equalTo: activityIndicator.trailingAnchor, constant: 5.0),
             clearButton.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor,
                                                   constant: -5.0)].map { $0.isActive = true }
    }
    
    func set(actions: AddressSearchBarActions,
             addressMode: AddressType?) {
        self.actions = actions
        self.presenter = KarhooAddressSearchBarPresenter(addressSearchBar: self,
                                                         addressMode: addressMode)
    }
    
    @objc
    private func searchChanged(_ sender: UITextField) {
        presenter?.searchTextChanged(text: sender.text)
        actions?.search(text: sender.text)
    }

    @objc
    private func clearPressed(_ sender: Any) {
        actions?.clearSearch()
    }

    func set(searchPlaceholder: String?) {
        searchTextField.placeholder = searchPlaceholder
    }

    func clearSearchInputField() {
        searchTextField.text = ""
    }

    func focusInputField() {
        searchTextField.becomeFirstResponder()
    }

    func unfocusInputField() {
        searchTextField.resignFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return searchTextField.resignFirstResponder()
    }

    func set(ringColor: UIColor) {
        ringIcon.backgroundColor = ringColor
    }
    
    func set(maxInputCharacters: Int) {
        maxChar = maxInputCharacters
    }
    
    func hideClearButton(hide: Bool) {
        clearButton.isHidden = hide
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
}

extension KarhooAddressSearchBar: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= maxChar
    }
}

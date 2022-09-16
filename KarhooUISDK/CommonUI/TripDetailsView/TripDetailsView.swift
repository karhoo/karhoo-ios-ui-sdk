//
//  TripDetailsView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHTripDetailsViewID {
    public static let supplierNameLabel = "supplier_name_label"
    public static let supplierImage = "supplier_image"
    public static let dateLabel = "date_label"
    public static let pickupLabel = "pickUp_label"
    public static let destinationLabel = "destination_label"
    public static let vehicleInformationLabel = "vehicle_info_label"
    public static let meetingPointType = "meeting_type_label"
}

final class TripDetailsView: UIView {
    
    private var stackContainer: UIStackView!
    private var detailsContainer: UIView!
    private var pickUpTypeContainer: UIView!
    
    private var didSetupConstraints: Bool = false
    private var supplierNameLabel: UILabel!
    private var supplierImage: LoadingImageView!
    private var dateLabel: UILabel!
    private var pickUpDot: UIImageView!
    private var pickupLabel: UILabel!
    private var destinationLabel: UILabel!
    private var dropOffDot: UIImageView!
    private var connectorLine: LineView!
    private var vehicleInformationLabel: UILabel!
    private var meetingPointType: RoundedLabel!
    private var bottomLineSeparator: LineView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
        self.prepareForReuse()
    }
    
    // MARK: View setup
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "tripDetails_view"
        
        stackContainer = UIStackView()
        stackContainer.accessibilityIdentifier = "stack_container"
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.axis = .vertical
        addSubview(stackContainer)
        
        detailsContainer = UIView()
        detailsContainer.isAccessibilityElement = true
        detailsContainer.accessibilityIdentifier = "details_container"
        detailsContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.addArrangedSubview(detailsContainer)
        
        supplierImage = buildSupplierImage()
        
        supplierNameLabel = buildGenericLabel(textColor: KarhooUI.colors.darkGrey,
                                              font: KarhooUI.fonts.headerBold(),
                                              accessibilityIdentifier: KHTripDetailsViewID.supplierNameLabel)
        detailsContainer.addSubview(supplierNameLabel)
        
        dateLabel = buildGenericLabel(textColor: KarhooUI.colors.medGrey,
                                      font: KarhooUI.fonts.bodyRegular(),
                                      accessibilityIdentifier: KHTripDetailsViewID.dateLabel)
        detailsContainer.addSubview(dateLabel)
        
        pickUpDot = buildDot(color: KarhooUI.colors.primary,
                             accessibilityIdentifier: "pick_up_dot")
        
        pickupLabel = buildGenericLabel(textColor: KarhooUI.colors.darkGrey,
                                        font: KarhooUI.fonts.bodyRegular(),
                                        accessibilityIdentifier: KHTripDetailsViewID.pickupLabel)
        detailsContainer.addSubview(pickupLabel)
        
        dropOffDot = buildDot(color: KarhooUI.colors.secondary,
                              accessibilityIdentifier: "drop_off_dot")
        
        destinationLabel = buildGenericLabel(textColor: KarhooUI.colors.darkGrey,
                                             font: KarhooUI.fonts.bodyRegular(),
                                             accessibilityIdentifier: KHTripDetailsViewID.destinationLabel)
        detailsContainer.addSubview(destinationLabel)
        
        connectorLine = LineView(color: .lightGray,
                                 width: 1.0,
                                 accessibilityIdentifier: "connector_line")
        detailsContainer.addSubview(connectorLine)
        
        vehicleInformationLabel = buildGenericLabel(textColor: KarhooUI.colors.medGrey,
                                                    font: KarhooUI.fonts.bodyRegular(),
                                                    accessibilityIdentifier: KHTripDetailsViewID
                                                        .vehicleInformationLabel)
        detailsContainer.addSubview(vehicleInformationLabel)
        
        pickUpTypeContainer = UIView()
        pickUpTypeContainer.accessibilityIdentifier = "pickUp_type_container"
        pickUpTypeContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.addArrangedSubview(pickUpTypeContainer)
        
        meetingPointType = RoundedLabel()
        meetingPointType.accessibilityIdentifier = KHTripDetailsViewID.meetingPointType
        meetingPointType.translatesAutoresizingMaskIntoConstraints = false
        meetingPointType.textInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        meetingPointType.maskToBounds = true
        meetingPointType.cornerRadious = true
        meetingPointType.textColor = KarhooUI.colors.white
        meetingPointType.backgroundColor = KarhooUI.colors.darkGrey
        pickUpTypeContainer.addSubview(meetingPointType)
        
        bottomLineSeparator = LineView(color: .lightGray,
                                       accessibilityIdentifier: "tripDetails_bottom_separator_line")
        bottomLineSeparator.isHidden = true
        stackContainer.addArrangedSubview(bottomLineSeparator)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            _ = [stackContainer.topAnchor.constraint(equalTo: topAnchor),
                 stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                 stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
                 stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
            
            _ = [detailsContainer.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor),
                 detailsContainer.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor)]
                .map { $0.isActive = true }
            
            let imageSize: CGFloat = 40.0
            _ = [supplierImage.topAnchor.constraint(equalTo: detailsContainer.topAnchor, constant: 10.0),
                 supplierImage.trailingAnchor.constraint(equalTo: detailsContainer.trailingAnchor, constant: -10.0),
                 supplierImage.widthAnchor.constraint(equalToConstant: imageSize),
                 supplierImage.heightAnchor.constraint(equalToConstant: imageSize)].map { $0.isActive = true }
            
            _ = [supplierNameLabel.topAnchor.constraint(equalTo: detailsContainer.topAnchor, constant: 10.0),
                 supplierNameLabel.leadingAnchor.constraint(equalTo: detailsContainer.leadingAnchor, constant: 10.0),
                 supplierNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: supplierImage.leadingAnchor,
                                                             constant: -10.0)].map { $0.isActive = true}
            
            _ = [dateLabel.topAnchor.constraint(equalTo: supplierNameLabel.bottomAnchor, constant: 5.0),
                 dateLabel.leadingAnchor.constraint(equalTo: supplierNameLabel.leadingAnchor),
                 dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: supplierImage.leadingAnchor, constant: -10.0)]
                .map { $0.isActive = true }
            
            let dotImageSize: CGFloat = 15.0
            _ = [pickUpDot.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
                 pickUpDot.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10.0),
                 pickUpDot.widthAnchor.constraint(equalToConstant: dotImageSize),
                 pickUpDot.heightAnchor.constraint(equalToConstant: dotImageSize)].map { $0.isActive = true }
            
            _ = [pickupLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 7.0),
                 pickupLabel.leadingAnchor.constraint(equalTo: pickUpDot.trailingAnchor, constant: 10.0),
                 pickupLabel.trailingAnchor.constraint(lessThanOrEqualTo: detailsContainer.trailingAnchor,
                                                       constant: -20.0)].map { $0.isActive = true }
            
            _ = [dropOffDot.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
                 dropOffDot.topAnchor.constraint(equalTo: pickupLabel.bottomAnchor, constant: 12.0),
                 dropOffDot.widthAnchor.constraint(equalToConstant: dotImageSize),
                 dropOffDot.heightAnchor.constraint(equalToConstant: dotImageSize)].map { $0.isActive = true }
            
            _ = [destinationLabel.topAnchor.constraint(equalTo: pickupLabel.bottomAnchor, constant: 10.0),
                 destinationLabel.leadingAnchor.constraint(equalTo: dropOffDot.trailingAnchor, constant: 10.0),
                 destinationLabel.trailingAnchor.constraint(lessThanOrEqualTo: detailsContainer.trailingAnchor,
                                                            constant: -20.0)].map { $0.isActive = true }
            
            _ = [connectorLine.centerXAnchor.constraint(equalTo: pickUpDot.centerXAnchor),
                 connectorLine.topAnchor.constraint(equalTo: pickUpDot.bottomAnchor, constant: 2.0),
                 connectorLine.bottomAnchor.constraint(equalTo: dropOffDot.topAnchor,
                                                       constant: -2.0)].map { $0.isActive = true }
            
            _ = [vehicleInformationLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 10.0),
                 vehicleInformationLabel.leadingAnchor.constraint(equalTo: supplierNameLabel.leadingAnchor),
                 vehicleInformationLabel.trailingAnchor.constraint(lessThanOrEqualTo: supplierImage.leadingAnchor,
                                                                   constant: -10.0),
                 vehicleInformationLabel.bottomAnchor.constraint(lessThanOrEqualTo: detailsContainer.bottomAnchor,
                                                                 constant: -5.0)].map { $0.isActive = true }
            
            _ = [pickUpTypeContainer.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor),
                 pickUpTypeContainer.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor)]
                .map { $0.isActive = true }
            
            _ = [meetingPointType.topAnchor.constraint(equalTo: pickUpTypeContainer.topAnchor),
                 meetingPointType.bottomAnchor.constraint(equalTo: pickUpTypeContainer.bottomAnchor, constant: -5.0),
                 meetingPointType.leadingAnchor.constraint(equalTo: pickUpTypeContainer.leadingAnchor,
                                                           constant: 10.0)].map { $0.isActive = true }
            
            _ = [bottomLineSeparator.heightAnchor.constraint(equalToConstant: 1.0),
                 bottomLineSeparator.leadingAnchor.constraint(equalTo: stackContainer.leadingAnchor),
                 bottomLineSeparator.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor)]
                .map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !meetingPointType.cornerRadious {
            meetingPointType.cornerRadious = true
        }
        
        if pickUpDot.layer.cornerRadius == 0 && dropOffDot.layer.cornerRadius == 0 {
            pickUpDot.layer.cornerRadius = min(pickUpDot.frame.size.width, pickUpDot.frame.size.height) / 2
            dropOffDot.layer.cornerRadius = min(dropOffDot.frame.size.width, dropOffDot.frame.size.height) / 2
        }
    }
    
    func set(viewModel: TripDetailsViewModel) {
        supplierNameLabel?.text = viewModel.supplierName
        dateLabel.text = viewModel.formattedDate
        supplierImage.load(imageURL: viewModel.supplierLogoStringURL,
                           placeholderImageName: "kh_fleet_logo_placeholder")
        pickupLabel.text = viewModel.pickup
        destinationLabel.text = viewModel.destination
        vehicleInformationLabel?.text = viewModel.vehicleInformation
        pickUpTypeContainer.isHidden = !viewModel.showMeetingPoint
        meetingPointType.text = viewModel.meetingPointText
        detailsContainer.accessibilityLabel = "\(viewModel.supplierName), \(viewModel.accessibilityDate), \(viewModel.pickup), \(viewModel.destination), \(viewModel.vehicleInformation)"
    }
    
    func prepareForReuse() {
        supplierNameLabel?.text = ""
        dateLabel?.text = ""
        supplierImage?.cancel()
        pickupLabel?.text = ""
        destinationLabel?.text = ""
        vehicleInformationLabel?.text = ""
        meetingPointType?.text = ""
    }
    
    public func isBottomLineSeparatorHidden(_ value: Bool) {
        bottomLineSeparator.isHidden = value
    }
}

// MARK: Builders
private extension TripDetailsView {
    
    func buildSupplierImage() -> LoadingImageView {
        let imageView = LoadingImageView()
        imageView.accessibilityIdentifier = KHTripDetailsViewID.supplierImage
        detailsContainer.addSubview(imageView)
        
        return imageView
    }
    
    func buildDot(image: UIImage? = nil,
                  color: UIColor? = .black,
                  accessibilityIdentifier: String) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = accessibilityIdentifier
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = color
        imageView.image = image != nil ? image : nil
        detailsContainer.addSubview(imageView)
        
        return imageView
    }
    
    func buildGenericLabel(textColor: UIColor? = .black,
                           font: UIFont? = UIFont.systemFont(ofSize: 17),
                           text: String = "",
                           accessibilityIdentifier: String) -> UILabel {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.accessibilityIdentifier = accessibilityIdentifier
        label.textColor = textColor
        label.font = font
        label.text = text
        
        return label
    }
}

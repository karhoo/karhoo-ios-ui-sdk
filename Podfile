# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

# Standard cocoapods specs source
source 'https://cdn.cocoapods.org/'

use_frameworks!

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings[‘ONLY_ACTIVE_ARCH’] = ‘YES’
      config.build_settings[“EXCLUDED_ARCHS[sdk=iphonesimulator*]“] = “arm64”
      config.build_settings[‘BUILD_LIBRARY_FOR_DISTRIBUTION’] = ‘YES’
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
  end
end

# suppress error of duplicate uuids on pod install: https://github.com/ivpusic/react-native-image-crop-picker/issues/680
install! 'cocoapods',
         :deterministic_uuids => false

target 'Client' do
  inherit! :search_paths
  pod 'KarhooUISDK', :path => './'
  pod 'KarhooUISDK/Adyen', :path => './'
  pod 'KarhooUISDK/Braintree', :path => './'

end

# UISDK framework
target 'KarhooUISDK' do
#  pod 'KarhooSDK', :git => 'https://github.com/karhoo/karhoo-ios-sdk', :branch => 'feature/MOB-4493-update-architecture-settings'
  pod 'KarhooSDK', :git => 'https://github.com/karhoo/karhoo-ios-sdk', :branch => 'master'
#  pod 'KarhooSDK', '1.7.1'
  pod 'SwiftLint', '~> 0.47'
  pod 'PhoneNumberKit', '3.3.1'
  pod 'SwiftFormat/CLI', '~> 0.49'
  pod 'BraintreeDropIn', '~> 9.8.0'
  pod 'Braintree/PaymentFlow', '~> 5.20.1'
  pod 'Adyen', '4.7.2'

  target 'KarhooUISDKTests' do
    inherit! :complete
    pod 'SnapshotTesting', '1.9.0'
    pod 'Quick', '~> 5.0.1'
    pod 'Nimble', '~> 10.0.0'
  end

  target 'KarhooUISDKUITests' do
    inherit! :complete
    pod 'SnapshotTesting', '1.9.0'
    pod 'Quick', '~> 5.0.1'
    pod 'Nimble', '~> 10.0.0'
  end

  target 'KarhooUISDKTestUtils' do
    inherit! :complete
  end
end

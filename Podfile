# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Standard cocoapods specs source
source 'https://cdn.cocoapods.org/'

use_frameworks!

# suppress error of duplicate uuids on pod install: https://github.com/ivpusic/react-native-image-crop-picker/issues/680
install! 'cocoapods',
         :deterministic_uuids => false

def common_pods
  pod 'Adyen', '3.7.0'
  pod 'KarhooSDK', :git => 'git@github.com:karhoo/karhoo-ios-sdk.git', :commit => 'e00e9df888ffe9fa75b29e6c4ecdeca802254464'
#  pod 'KarhooSDK', :git => 'git@github.com:karhoo/karhoo-ios-sdk.git', :branch => 'develop'
#  pod 'KarhooSDK', '1.5.5'
end

target 'Client' do
  inherit! :search_paths
  pod 'KarhooUISDK', :path => './'
end

# UISDK framework
target 'KarhooUISDK' do
  common_pods
  pod 'BraintreeDropIn', '~> 8.1'
  pod 'Braintree/PaymentFlow', '~> 4.37'
  pod 'SwiftLint'
  pod 'Adyen', '3.7.0'
  pod 'PhoneNumberKit', '3.3.1'
end

# UISDK unit tests
target 'KarhooUISDKTests' do
  inherit! :search_paths
  common_pods
end

# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Standard cocoapods specs source
source 'https://cdn.cocoapods.org/'

use_frameworks!

# suppress error of duplicate uuids on pod install: https://github.com/ivpusic/react-native-image-crop-picker/issues/680
install! 'cocoapods',
         :deterministic_uuids => false

def common_pods
# pod 'KarhooSDK', :git => 'git@github.com:karhoo/karhoo-ios-sdk.git', :branch => 'MOB-4020-release-1.6'
   pod 'KarhooSDK', '1.6.1'
end

target 'Client' do
  inherit! :search_paths
  pod 'KarhooUISDK', :path => './'
end

# UISDK framework
target 'KarhooUISDK' do
  common_pods
  pod 'FloatingPanel', '2.0.1'
  pod 'BraintreeDropIn', '~> 8.1'
  pod 'Braintree/PaymentFlow', '~> 4.37'
  pod 'SwiftLint', '~> 0.47'
  pod 'Adyen', '4.7.1'
  pod 'PhoneNumberKit', '3.3.1'
end

# UISDK unit tests
target 'KarhooUISDKTests' do
  inherit! :search_paths
  common_pods
end

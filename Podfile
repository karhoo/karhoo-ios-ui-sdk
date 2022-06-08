# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Standard cocoapods specs source
source 'https://cdn.cocoapods.org/'

use_frameworks!

# suppress error of duplicate uuids on pod install: https://github.com/ivpusic/react-native-image-crop-picker/issues/680
install! 'cocoapods',
         :deterministic_uuids => false

pod 'KarhooUISDK', :path => './'
pod 'KarhooSDK', '1.6.2'

target 'Client' do
  inherit! :search_paths
  pod 'KarhooUISDK/Adyen', :path => './'
  pod 'KarhooUISDK/Braintree', :path => './'

end

# UISDK framework
target 'KarhooUISDK' do
  pod 'FloatingPanel', '2.0.1'
  pod 'SwiftLint', '~> 0.47'
  pod 'PhoneNumberKit', '3.3.1'
  pod 'SwiftFormat/CLI', '~> 0.49'
  pod 'BraintreeDropIn', '~> 8.1'
  pod 'Braintree/PaymentFlow', '~> 4.37'
  pod 'Adyen', '4.7.1'
end

# UISDK unit tests
# target 'KarhooUISDKTests' do
# end

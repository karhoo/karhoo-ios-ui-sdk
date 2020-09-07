# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
 

# Standard cocoapods specs source
source 'https://github.com/CocoaPods/Specs.git'
 

use_frameworks!

# suppress error of duplocate uuids on pod install: https://github.com/ivpusic/react-native-image-crop-picker/issues/680
install! 'cocoapods',
         :deterministic_uuids => false

def uisdkPods
  pod 'FloatingPanel'
  pod 'BraintreeDropIn'
  pod 'Braintree/PaymentFlow'
  pod 'SwiftLint'
  pod 'Adyen'
  pod 'PhoneNumberKit', '2.1.0'
  # pod 'KarhooSDK', '1.1.1'
  pod 'KarhooSDK', :git => 'git@github.com:karhoo/karhoo-ios-sdk.git', :branch => 'develop'

end

target 'Client' do
  inherit! :search_paths
  pod 'KarhooUISDK', :path => './'
end

# UISDK framework
target 'KarhooUISDK' do
    uisdkPods

     # UISDK unit tests
    target 'KarhooUISDKTests' do
      inherit! :search_paths
      uisdkPods
    end

end





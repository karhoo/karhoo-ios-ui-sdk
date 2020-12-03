# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Standard cocoapods specs source
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

# suppress error of duplocate uuids on pod install: https://github.com/ivpusic/react-native-image-crop-picker/issues/680
install! 'cocoapods',
         :deterministic_uuids => false

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

def uisdkPods
  pod 'FloatingPanel', '2.0.1'
  pod 'BraintreeDropIn'
  pod 'Braintree/PaymentFlow'
  pod 'SwiftLint'
  pod 'Adyen', '3.6.0'
  pod 'PhoneNumberKit', '3.3.1'
  #pod 'KarhooSDK'
  #pod 'KarhooSDK', :path => '../karhoo-ios-sdk'
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

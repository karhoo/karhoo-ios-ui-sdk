# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Standard cocoapods specs source
source 'https://cdn.cocoapods.org/'

use_frameworks!

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
#  pod 'KarhooSDK', '1.6.2'
  pod 'KarhooSDK', :git => 'https://github.com/karhoo/karhoo-ios-sdk', :commit => '8ec6f0959431fc5dd76e488f91b3a7f772f2aadc' # :branch => 'feature/MOB-4160-extract-correlationId'
  pod 'FloatingPanel', '2.0.1'
  pod 'SwiftLint', '~> 0.47'
  pod 'PhoneNumberKit', '3.3.1'
  pod 'SwiftFormat/CLI', '~> 0.49'
  pod 'BraintreeDropIn', '~> 8.1'
  pod 'Braintree/PaymentFlow', '~> 4.37'
  pod 'Adyen', '4.7.1'

  target 'KarhooUISDKTests' do
    inherit! :complete
  end
end

#post_install do |installer_representation|
 # installer_representation.pods_project.targets.each do |target|
  #  target.build_configurations.each do |config|
   #   config.build_settings[‘ONLY_ACTIVE_ARCH’] = ‘NO’
    #  config.build_settings[“EXCLUDED_ARCHS[sdk=iphonesimulator*]“] = “arm64”
     # config.build_settings[‘BUILD_LIBRARY_FOR_DISTRIBUTION’] = ‘YES’
#    end
 # end
# end

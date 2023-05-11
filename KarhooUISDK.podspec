Pod::Spec.new do |s|

  s.name                  = "KarhooUISDK"
  s.version               = "1.12.3"
  s.summary               = "Karhoo UI SDK"
  s.homepage              = "https://developer.karhoo.com/docs/build-apps-using-sdks"
  s.license               = 'BSD 2-Clause'
  s.author                = { "Karhoo" => "ios@karhoo.com" }
  s.source                = { :git => "https://github.com/karhoo/karhoo-ios-ui-sdk.git", :tag => s.version }
  s.platform              = :ios, '14.0'
  s.ios.deployment_target = '14.0'
  s.requires_arc          = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.dependency    'KarhooSDK'
    core.dependency    'PhoneNumberKit', '3.3.1'
    core.source_files = 'KarhooUISDK/**/*.swift'
    core.exclude_files = 'KarhooUISDK/Extensions/Bundle+extensions/BundleSPM+current.swift'
    core.resource_bundles = {
    'KarhooUISDKResource' => [
        'KarhooUISDK/**/*{xib,storyboard,xcassets,strings,stringsdict,bundle,lproj}'
    ]
  }
  end

  s.subspec 'Adyen' do |adyen|
    adyen.dependency    'KarhooUISDK/Core'
    adyen.dependency    'Adyen', '4.7.2'
    adyen.source_files = 'AdyenPSP/**/*.swift'
  end

  s.subspec 'Braintree' do |braintree|
    braintree.dependency    'KarhooUISDK/Core'
    braintree.dependency    'BraintreeDropIn', '~> 9.8.1'
    braintree.dependency    'Braintree/PaymentFlow', '~> 5.20.1'
    braintree.source_files = 'BraintreePSP/**/*.swift'
  end


end

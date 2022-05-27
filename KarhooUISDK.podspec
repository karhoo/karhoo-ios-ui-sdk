Pod::Spec.new do |s|

  s.name                  = "KarhooUISDK"
  s.version               = "1.7.3"
  s.summary               = "Karhoo UI SDK"
  s.homepage              = "https://developer.karhoo.com/docs/build-apps-using-sdks"
  s.license               = 'BSD 2-Clause'
  s.author                = { "Karhoo" => "ios@karhoo.com" }

  s.source                = { :git => "https://github.com/karhoo/karhoo-ios-ui-sdk.git", :tag => s.version }
  s.source_files          = 'KarhooUISDK/**/*.swift'

  s.resource_bundles = {
    'KarhooUISDK' => [
        'KarhooUISDK/**/*{xib,storyboard,xcassets,strings,stringsdict,bundle,lproj}'
    ]
  }


  s.platform              = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.exclude_files = 'KarhooUISDK/Extensions/Bundle+extensions/BundleSPM+current.swift'

  s.requires_arc          = true

  s.dependency    'KarhooSDK'
  s.dependency 	  'FloatingPanel', '2.0.1'
  s.dependency    'PhoneNumberKit', '3.3.1'

  s.default_subspec = 'Core'
  s.subspec 'Core' do |core|
  end

  s.subspec 'Adyen' do |adyen|
    adyen.dependency    'KarhooUISDK/Core'
    adyen.dependency    'Adyen', '4.7.1'
    adyen.source_files = 'AdyenPSP/**/*.swift'
  end

  s.subspec 'Braintree' do |braintree|
    braintree.dependency    'KarhooUISDK/Core'
    braintree.dependency    'BraintreeDropIn', '~> 8.1'
    braintree.dependency    'Braintree/PaymentFlow', '~> 4.37'
    braintree.source_files = 'BraintreePSP/**/*.swift'
  end


end

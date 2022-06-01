Pod::Spec.new do |s|

  s.name                  = "KarhooUISDK"
  s.version               = "1.7.3"
  s.summary               = "Karhoo UI SDK"
  s.homepage              = "https://developer.karhoo.com/docs/build-apps-using-sdks"
  s.license               = 'BSD 2-Clause'
  s.author                = { "Karhoo" => "ios@karhoo.com" }
  s.source                = { :git => "https://github.com/karhoo/karhoo-ios-ui-sdk.git", :tag => s.version }
  s.platform              = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.requires_arc          = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.dependency    'KarhooSDK'
    core.dependency    'FloatingPanel', '2.0.1'
    core.dependency    'PhoneNumberKit', '3.3.1'
    core.source_files = 'KarhooUISDK/**/*.swift'
    core.exclude_files = 'KarhooUISDK/Extensions/Bundle+extensions/BundleSPM+current.swift'
    core.resource_bundles = {
    'KarhooUISDK' => [
        'KarhooUISDK/**/*{xib,storyboard,xcassets,strings,stringsdict,bundle,lproj}'
    ]
  }
  end

  s.subspec 'Adyen' do |adyen|
    adyen.dependency    'KarhooUISDK/Core'
    adyen.source_files = 'AdyenPSP/**/*.swift'
  end

  s.subspec 'Braintree' do |braintree|
    braintree.dependency    'KarhooUISDK/Core'
    braintree.source_files = 'BraintreePSP/**/*.swift'
  end


end

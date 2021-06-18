Pod::Spec.new do |s|

  s.name                  = "KarhooUISDK"
  s.version               = "1.5.1"

  s.summary               = "UI SDK for the Karhoo platform"
  s.homepage              = "https://github.com/karhoo/Karhoo-iOS-UI-SDK.git"
  s.license               = 'MIT'
  s.author                = { "Karhoo" => "ios@karhoo.com" }

  s.source                = { :git => "git@github.com:karhoo/Karhoo-iOS-UI-SDK.git", :tag => s.version }
  s.source_files          = 'KarhooUISDK/**/*.swift' 

  s.resource_bundles = {
    'KarhooUISDK' => [
        'KarhooUISDK/**/*{xib,storyboard,xcassets,strings,stringsdict,bundle,lproj}'
    ]
  }

  s.platform              = :ios, '11.0'
  s.ios.deployment_target = '11.0'

  s.requires_arc          = true

  s.dependency    'KarhooSDK'
  s.dependency 	  'FloatingPanel', '2.0.1'
  s.dependency    'BraintreeDropIn', '~> 8.1'
  s.dependency    'Braintree/PaymentFlow', '~> 4.37'
  s.dependency    'PhoneNumberKit', '3.3.1'
  s.dependency    'Adyen', '3.6.0'

end

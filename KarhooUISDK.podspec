Pod::Spec.new do |s|

  s.name                  = "KarhooUISDK"
  s.version               = "1.2.6"

  s.summary               = "UI SDK for the Karhoo platform"
  s.homepage              = "https://github.com/karhoo/Karhoo-iOS-UI-SDK.git"
  s.license               = 'MIT'
  s.author                = { "Karhoo" => "ios@karhoo.com" }

  s.source                = { :git => "git@github.com:karhoo/Karhoo-iOS-UI-SDK.git", :tag => s.version }
  s.source_files          = 'KarhooUISDK/**/*.swift' 

  s.resource_bundles = {
    'KarhooUISDK' => [
        'KarhooUISDK/**/*{xib,storyboard,xcassets,strings,bundle,lproj}'
    ]
  }

  s.platform              = :ios, '11.0'
  s.ios.deployment_target = '11.0'

  s.requires_arc          = true

  s.dependency    'KarhooSDK'
  s.dependency 	  'FloatingPanel'
  s.dependency    'BraintreeDropIn'
  s.dependency    'Braintree/PaymentFlow'
  s.dependency    'PhoneNumberKit'
  s.dependency    'Adyen'

end

Pod::Spec.new do |s|

  s.name                  = "KarhooUISDK"
  s.version               = "1.4.0"
  s.summary               = "UI SDK for the Karhoo platform"
  s.homepage              = "https://github.com/karhoo/Karhoo-iOS-UI-SDK.git"
  s.license               = 'MIT'
  s.author                = { "Karhoo" => "ios@karhoo.com" }
  s.source                = { :git => "git@github.com:karhoo/Karhoo-iOS-UI-SDK.git", :tag => s.version }
  s.platform              = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.requires_arc          = true

  s.subspec "BookingRequestComponent" do |component|
    component.source_files = "KarhooUISDK/#{component.base_name}/**/*.swift"
    component.resources = "KarhooUISDK/#{component.base_name}/Resources/**/*{xib,storyboard,xcassets,strings,bundle,lproj}"
    component.dependency 'Adyen', '3.6.0'
    component.dependency 'BraintreeDropIn'
    component.dependency 'Braintree/PaymentFlow'
    component.dependency 'KarhooSDK'
    component.dependency 'KarhooUISDK/Common'
  end

  s.subspec "Common" do |component|
    component.source_files = "KarhooUISDK/#{component.base_name}/**/*.swift"
    component.resources = "KarhooUISDK/#{component.base_name}/**/*{xib,storyboard,xcassets,strings,bundle,lproj}"
    component.dependency 'KarhooSDK'
    component.dependency 'PhoneNumberKit', '3.3.1'
  end

  s.subspec "AllComponents" do |component|
    component.source_files = 'KarhooUISDK/**/*.swift' 
    component.resources = 'KarhooUISDK/**/*{xib,storyboard,xcassets,strings,bundle,lproj}'
    component.dependency 'Adyen', '3.6.0'
    component.dependency 'BraintreeDropIn'
    component.dependency 'Braintree/PaymentFlow'
    component.dependency 'KarhooSDK'
    component.dependency 'FloatingPanel', '2.0.1'
    component.dependency 'KarhooUISDK/Common'
    component.dependency 'KarhooUISDK/Common'
  end
end

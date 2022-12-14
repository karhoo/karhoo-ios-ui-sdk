<div align="center">
<a href="https://karhoo.com">
<img
alt="Karhoo logo"
width="250px"
src="https://cdn.karhoo.com/s/images/logos/karhoo_logo.png"
/>
</a>
</div>

# Karhoo iOS UI SDK

The UI SDK extends on our [**Network SDK**](https://github.com/karhoo/karhoo-ios-sdk) with ready to use screens and views for your end users to book rides with [**Karhoo**](https://karhoo.com/) in your application.

For more general information about the SDKs, chechout [**the karhoo developer portal**](https://developer.karhoo.com/docs/build-apps-using-sdks)

<a href="https://gph.is/g/aQqR1p2" target="_blank">Visual Demo</a>

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `KarhooUISDK` by adding it to your `Podfile`:

```ruby

use_frameworks!
pod 'KarhooSDK', '1.7.0'
pod 'KarhooUISDK', :git => 'git@github.com:karhoo/karhoo-ios-ui-sdk.git', :tag => '1.9.4'
```
Depending on payment provider you want to use in your integration add:
```ruby
pod 'KarhooUISDK/Adyen', :git => 'git@github.com:karhoo/karhoo-ios-ui-sdk.git', :tag => '1.9.4'
```
or
```ruby
pod 'KarhooUISDK/Braintree', :git => 'git@github.com:karhoo/karhoo-ios-ui-sdk.git', :tag => '1.9.4'
```

then import `KarhooUISDK` wherever you want to access Karhoo services

``` swift
import KarhooUISDK
```

#### Swift Package Manager
KarhooUISDK is released as a SPM beginning from version 1.8.0
Use URL for repository: `https://github.com/karhoo/karhoo-ios-ui-sdk`

and you will find 3 available packages:
`KarhooUISDK`: only core package, 	
`KarhooUISDKAdyen`: core + Adyen payment provider
`KarhooUISDKBraintree`: core + Braintree Payment Provider

then import `KarhooUISDK` wherever you want to access Karhoo services

# Contribution Guide 
Install Cocoapods 
`brew install cocoapods`


Run 
`pod install`

Open  KarhooUISDK.xcworkspace 

## Running Tests
There is an Xcode scheme for unit tests. Unit tests test the functionality of individual classes using mocked dependencies. 

## Client example
There is an example project inside the Client directory of this repository. This is meant to be a fast way to test SDK changes and development steps.  You will need to add access Keys to the client module as these are ignored due to this being an open source repository. 

```swift
struct Keys {
static let identifier = ""
...
}
```


## License
[BSD-2-Clause](./LICENSE)



<div align="center">
<a href="https://karhoo.com">
<img
alt="Karhoo logo"
width="250px"
src="https://cdn.karhoo.com/s/images/logos/karhoo_logo.png"
/>
</a>
</div>

<h1>Karhoo iOS UI SDK</h1>

The UI SDK extends on our [**Network SDK**](https://github.com/karhoo/karhoo-ios-sdk) with ready to use screens and views for your end users to book rides with [**Karhoo**](https://karhoo.com/) in your application.

[**Read The Docs**](https://developer.karhoo.com/docs/build-apps-using-sdks)


## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `KarhooUISDK` by adding it to your `Podfile`:

```ruby

use_frameworks!
pod 'KarhooUISDK', :git => 'https://github.com/Karhoo/karhoo-ios-ui-sdk.git', :tag => '1.2.6'
```

then import `KarhooUISDK` wherever you want to access Karhoo services

``` swift
import KarhooUISDK
```

# Setup For Development 
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

## Issues

_Looking to contribute?_

### 🐛 Bugs

Please file an issue for bugs, missing documentation, or unexpected behavior.

### 💡 Feature Requests

Please file an issue to suggest new features. Vote on feature requests by adding
a 👍. This helps maintainers prioritize what to work on.

### ❓ Questions

For questions related to using the library, please re-visit a documentation first. If there are no answer, please create an issue with a label `help needed`.

## Useful Links

[Karhoo Developer Site](https://developer.karhoo.com/)

[The iOS Network SDK](https://github.com/karhoo/karhoo-ios-sdk)

## License
[BSD-2-Clause](./LICENSE)



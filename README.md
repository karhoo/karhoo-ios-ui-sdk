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
pod 'KarhooSDK', '1.5.5'
pod 'KarhooUISDK', :git => 'git@github.com:karhoo/karhoo-ios-ui-sdk.git', :tag => '1.7.2'
```

then import `KarhooUISDK` wherever you want to access Karhoo services

``` swift
import KarhooUISDK
```

## Usage

## Initialisation

There are a few things the UI SDK needs to know before you can get started. Such as what environment to connect to, or what kind of authentication method to use. These dependencies can be set up in an implementation of the KarhooUISDKConfiguration protocol.

```swift
import KarhooUISDK

struct YourCompanyKarhooConfiguration: KarhooUISDKConfiguration {
    
    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
    // for other authentication methods such as guest or token exchange bookings please see: https://developer.karhoo.com/docs/using-the-network-sdk#authentication
        return .karhooUser
    }
}
```

With this configuration the UISDK can be initialised in your App/SceneDelegate. This will also ensure the network layer (KarhooSDK) is initialised. 

```swift
import KarhooUISDK

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KarhooUI.set(configuration: YourCompanyKarhooConfiguration())
       ..
        return true
    }
}
```

For full documentation of SDK services please visit our Developer Portal: https://developer.karhoo.com/reference#user-service

## Authentication

The KarhooSDK requires authentication, attempting to interact with the SDKs without authenticating will result in errors. There are three possible authentication methods supported:

### Karhoo User

A user that is created and managed within the Karhoo platform. Karhoo users are useful for corporate travel and proof of concept integrations. Setup your KarhooSDKConfiguration interface authentication method as ```.karhooUser```. Then you can use the UserService to make a login request with a username and password.

```swift
let userService = Karhoo.getUserService()
let userLogin = UserLogin(email: "your-user@email.com", password: "abc")

userService.login(userLogin: userLogin).execute { result in
    switch result {
    case .success(let user):
        print("user authenticated: ", user)
    case .failure(let error):
        print("error: \(error.code) \(error.message)")
    }
}
```

### Guest User

Guest users are anonymous and useful for B2C traveller solutions. When booking as a guest user, the user of your application will not be required to authenticate, however you will be required to provide passenger details when making a booking with the trip service. To setup the SDK in guest mode, specify the authentication method in your KarhooSDKConfiguration interface as ``` .guest``` and provide your credentials as an associated value. After that, you'll be able to interact with the SDK services. 

```swift
struct YourCompanyKarhooConfiguration: KarhooSDKConfiguration {
    
    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return .guest(settings: GuestSettings(identifier: "", 
                                              referer: "", 
                                              organisationId: ""))
    }
}
```


### Token Exchange

It is also possible to sync your users with the Karhoo platform so you can swap your users JWT token for a karhoo user token. This allows your users to automatically authenticate and use Karhoo services. If your integration involves this authentication method you can setup the SDK accordingy using the ```AuthService```

Firstly, specify ```.tokenExchange``` as the authentication method in your SDK configuration file.

```swift
struct YourCompanyKarhooConfiguration: KarhooSDKConfiguration {
    
    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return .tokenExchange(settings: TokenExchangeSettings(clientId: "", 
                                                              scope: ""))
    }
}
```

Then use the ```AuthService``` to swap your JWT for a Karhoo user.

```swift
let authService = Karhoo.getAuthService()

authService.login(token: "user-jwt").execute { result in
    switch result {
    case .success(let user):
        print("user authenticated: ", user)
    case .failure(let error):
        print("error: \(error.code) \(error.message)")
    }
}
```

## Features

Once the SDK is authenticated you can use it to show pre-built but customisable UIViewControllers and UIViews. Consider this framework like a UI API. You feed certain parameters into the view controllers and views, and your end users interactions with the views triggers actionable output.  

### Screens

Within ```KarhooUI().screens()``` are a selection of UIViewControllers. The full list of available screens are listed [**here in our developer portal**](https://developer.karhoo.com/reference#uk-sdk-address-screen). The SDK uses the builder pattern to generate UIViewcontrollers and UIViews, inside the builders the sdk initialises and binds business logic to the UI so interactions are handled, Here's an example of how to build the main booking screen:


<div align="center">
<a href="https://karhoo.com">
<img
alt="Karhoo booking screen"
width="400px"
src="https://i.ibb.co/hX6MSqm/Simulator-Screen-Shot-i-Phone-8-Plus-2020-11-03-at-14-47-27.png"
/>
</a>
</div>

```swift

private var bookingScreen: BookingScreen?

bookingScreen = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: nil, // prefill origin / drop off / date data
                                                                  passengerDetails: nil, //prefill booking details with customer info
                                                                  callback: { [weak self] result in
                                                                        switch result {
                                                                        case .completed(let bookingScreenResult):
                                                                            switch bookingScreenResult {
                                                                            case .tripAllocated(let trip): print("did book trip: ", trip)
                                                                            default: break
                                                                            }
                                                                        default: break
                                                                        }
                                                                    }) as? BookingScreen
self.present(bookingScreen!, animated: true, completion: nil)

```

### View Components

As well as UIViewControllers the SDK offers the UIViews that make up its UIViewControllers. This can be helpful if you want to have more control over your end users experience, or integrate very specific features into your app, such as choosing addresses or booking an existing quote. Avialable components are found in ```karhooUI.components```. Here's an example of the address bar from the booking screen.  

```swift

import KarhooUISDK

private var addressBar: AddressBarView!

addressBar = KarhooUI.components.addressBar(journeyInfo: nil) //prefill component with data. eg a pickup address
view.addSubview(addressBar)

// setup constraints on the component
_ = [addressBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
     addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, 
                                         constant: 10.0),
     addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                          constant: -10.0)].map { $0.isActive = true }

```

## Customisation
You can override aspects of the screens and components to align the UI SDK more towards your own brand. This includes the colour scheme, font, translations and custom routing within screens. 

### Translations / text copies
You can set any label text in any language by overriding the key / value pair in your apps localisation files. A full list of strings is available in 'KarhooUISDK/Translations' directory.  

```
"Text.GenericTripStatus.Arrived" = "Your Driver has arrived.";
```

### Assets
When populating UIImageViews the UISDK checks the main application bundle first for an image with the desired name. If it can't find an asset in the main bundle it will default to its own bundle. So to override any asset or image in the UISDK you can place the image with the right name in your asset bundle. A full list of assets can be found in ```/KarhooUISDK/Assets/Assets.xcassets```

### Color
The UI in this SDK conforms to a colour scheme, which is overridable by creating your own 'KarhooColors' implementation and injecting it to the SDK.

```swift
struct MyCompanyKarhooColors: KarhooColors { 
    
    var primary: UIColor {
        return .red
    }
}

// in your App/SceneDelegate, inject the colors:

KarhooUI.colors = MyCompanyKarhooColors()
```


### Fonts
Also you can use a custom FontFamily struct to inject your application font to provide a consistent user experience.

```swift
// full font list: https://gist.github.com/tadija/cb4ec0cbf0a89886d488d1d8b595d0e9

let myAppFontFamily = FontFamily(boldFont: String = "TrebuchetMS-Bold",
                                 regularFont: String = "TrebuchetMS",
                                 lightFont: String = "TrebuchetMS-Italic")
                                 
KarhooUI.fontFamily = myAppFontFamily
```

### Injectable routing

Each screen in the UISDK automatically routes to the next. You may want to only use particular screens in the UISDK and custom screens for others. For example you may want to book a trip with the UISDK but use your own address search screen. You can inject a routing implementation to override the navigation flow in the UISDK. To do this you would create your own screen builder and inject it into the SDK.

Create your own version of a screen e.g AddressScreen. (full list of screens are avialable in ```protocol ScreenBuilders```


```swift
// create your own screen
class MyCustomAddressScreenBuilder: AddressScreenBuilder {

        func buildAddressScreen(locationBias: CLLocation?,
                                addressType: AddressType,
                                callback: @escaping ScreenResultCallback<LocationInfo>) -> Screen {
            return MyCustomAddressViewController()                        
                                
        }
    
}

struct MyAppRouting: ScreenBuilders {

     var addressBuilder: AddressScreenBuilder {
        return MyAppAddressScreenBuilder()
    } 
}

// AppDelegate / SceneDelegate (setup custom routing)
KarhooUI.setRouting(routing: MyAppRouting())
```

Now whenever the user opens the address screen within the UISDK, it will open your address screen implementation when the user comes to enter a pickup or drop off point. 

## Issues

_Looking to contribute?_

### 🐛 Bugs

Please file an issue for bugs, missing documentation, or unexpected behavior.

### 💡 Feature Requests

Please file an issue to suggest new features. Vote on feature requests by adding
a 👍. This helps maintainers prioritize what to work on.

### ❓ Questions

For questions related to using the library, please re-visit a documentation first. If there are no answer, please create an issue with a label `help needed`.

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



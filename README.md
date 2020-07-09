<div align="center">
<a href="https://karhoo.com">
  <img
    alt="Karhoo logo"
    width="250px"
    src="https://cdn.karhoo.com/s/images/logos/karhoo_logo.png"
  />
</a>

<h1>Karhoo iOS UI SDK</h1>

The UI SDK extends on our [**Network SDK**](https://github.com/karhoo/karhoo-ios-sdk) with ready to use screens and views for your end users to book rides with [**Karhoo**](https://karhoo.com/) in your application.

<br />

[**Read The Docs**](https://developer.karhoo.com/docs/build-apps-using-sdks)

</div>

<hr />

## Introduction

The KarhooUISDK extends upon the Karhoo network SDK to give you the UI side of a ride hailing/booking experience. This is useful for POC integrations, whitelabel applications or faster integration into existing applications. The UISDK provides entry points for View Controllers (screens) and components (views), that interact with the KarhooAPI to give out of the box experiences for users.    


## Integration

Right now we support Cocoapods, so to add the UISDK to your project you can add the KarhooUISDK to your Podfile:

```
pod 'KarhooUISDK', :git => 'https://github.com/Karhoo/karhoo-ios-ui-sdk.git', :tag => '1.2.5'

```

We are working towards supporting Carthage, Swift Package Manager and we provide downloadable distributions on request for static integrations. You can also download releases and create your own artifact. Please do get in touch by raising an issue to get support for alternative dependency management systems. We are trying to build an open marketplace that is accessible to as many people as possible! :-) 

## Set up for developing the SDK

In order to setup the UI SDK, you can follow these steps:

- Clone this Repo
- Install dependencies in the project with <code>Pod install</code> 
- You can now open the KarhooUISDK.xcworkspace file

There are two targets in the Xcode project. The framework itself which you can archive for a static dependency, a client target for experimenting with the SDK within the project and an XCTest target (unit tests).

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

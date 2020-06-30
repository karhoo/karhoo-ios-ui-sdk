## Introduction

The KarhooUISDK extends upon the Karhoo network SDK to give you the UI side of a ride hailing/booking experience. This is useful for POC integrations, whitelabel applications or faster integration into existing applications. The UISDK provides entry points for View Controllers (screens) and components (views), that interact with the KarhooAPI to give out of the box experiences for users.    

## Setup

In order to setup the UI SDK, you can follow these steps below:

- Clone the Repo
- Navigate to the UISDK directory karhoo-ios-ui-sdk/
- Open terminal
- <code>Pod install</code> 
- This should install all the pods, including the Karhoo network SDK
- You can now open the KarhooUISDK.xcworkspace file

## Integration

Right now we support Cocoapods, so to add the UISDK to your project you can add the KarhooUISDK to your Podfile:

```
pod KarhooUISDK
```

We are working towards supporting Carthage, Swift Package Manager and we provide downloadable distributions on request for static integrations. Please do get in touch by raising an issue to get support for alternative dependency management systems. We are trying to build an open marketplace that is accessible to as many people as possible! :-) 

## Useful Links

[Developer Site](https://developer.karhoo.com/)

[SDK](https://github.com/karhoo/karhoo-ios-sdk)

fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios DangerPRValidation
```
fastlane ios DangerPRValidation
```
Danger PR Validation
### ios DangerPostCI
```
fastlane ios DangerPostCI
```
Danger publish test results
### ios unit_tests_integration_tests
```
fastlane ios unit_tests_integration_tests
```
Description of what the lane does
### ios XcovReport
```
fastlane ios XcovReport
```
Xcov Report

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

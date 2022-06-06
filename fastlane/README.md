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
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios DangerPRValidation
```
fastlane ios DangerPRValidation
```
Danger PR Validation
### ios iosDangerPostCI
```
fastlane ios iosDangerPostCI
```
Danger publish test results
### ios UISDK_unit_tests
```
fastlane ios UISDK_unit_tests
```
Run UISDK unit tests
### ios XcovReport
```
fastlane ios XcovReport
```
Xcov Report

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

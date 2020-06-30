#!/bin/bash

pod install

cd fastlane

fastlane ios TravellerApp_UnitTests

cd ..

pod install

fastlane ios UISDK_UnitTests
 

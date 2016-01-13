#!/bin/sh
xcodebuild archive -project YouPlay-iOS.xcodeproj -scheme YouPlay-iOS -archivePath YouPlay
xcodebuild -exportArchive -archivePath YouPlay.xcarchive -exportPath YouPlay -exportFormat ipa

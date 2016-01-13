#!/bin/sh
security create-keychain -p travis ios-build.keychain
#security import ./scripts/certs/sanliaoDistribution.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/certs/sanliaoDistribution.p12 -k ~/Library/Keychains/ios-build.keychain -P $ENCRYPTION_SECRET -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./scripts/profile/wujianguoAdHoc.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/

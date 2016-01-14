#!/bin/sh
security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security unlock-keychain -p travis ios-build.keychain
security set-keychain-settings -t 3600 -u iso-build.keychain
# security import ./scripts/certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
# security import ./scripts/certs/sanliaoDistribution.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./sanliaoDistribution.p12 -k ~/Library/Keychains/ios-build.keychain -P sanliao -T /usr/bin/codesign
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./wujianguoAdHoc.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/

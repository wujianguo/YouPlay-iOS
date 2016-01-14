#!/bin/sh
# - xctool -project $APP_NAME.xcodeproj -scheme $APP_NAME -sdk iphonesimulator ONLY_ACTIVE_ARCH=YES

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/Release-iphoneos"

xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APP_NAME.app" -o "$OUTPUTDIR/$APP_NAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"

curl -F "file=@$OUTPUTDIR/$APP_NAME.ipa" \
     -F "uKey=$PGYER_USER_KEY" \
     -F "_api_key=$PGYER_API_KEY" \
     http://www.pgyer.com/apiv1/app/upload

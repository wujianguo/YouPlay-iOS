#!/bin/sh
xcodebuild archive -project $APP_NAME.xcodeproj -scheme $APP_NAME -archivePath $APP_NAME
xcodebuild -exportArchive -archivePath $APP_NAME.xcarchive -exportPath $APP_NAME -exportFormat ipa
curl -F "file=@$APP_NAME.ipa" \
     -F "uKey=$PGYER_USER_KEY" \
     -F "_api_key=$PGYER_API_KEY" \
     http://www.pgyer.com/apiv1/app/upload

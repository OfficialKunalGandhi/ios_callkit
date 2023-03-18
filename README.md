# ios_callkit

One-to-one video call using CallKit and PushKit with flutter iOS app.

## Motivation

We need to use CallKit to handle incoming VoIP notifications from iOS 13. [Check the WWDC2019 video for more information](https://developer.apple.com/videos/play/wwdc2019/707/). So instead of using CallKit and PushKit separately, there is a growing need to use them together. However, there are still few VoIP notification samples on the net that use CallKit and PushKit (especially for Flutter). I decided to create a flutter plugin with the minimum required functions. **You can use this plugin, but the actual purpose is to help you create a VoIPKit tailored to your service.**

## Requirement

- iOS only, not support Android.
- iOS 10 or above.
- one-to-one call only, not support group call.
- need to a server for pushing VoIP notification with APNs.
- to actually make a video or call, you need to link to a service such as WebRTC（ex: Agora, SkyWay, Amazon Kinesis Video Streams）.

## Usage

### 1. install

- Add `ios_callkit` as a dependency in your pubspec.yaml file.

### 2. setting Capability in Xcode

1. Select Background Modes > Voice over IP and Remote notifications is ON.
1. Select Push Notifications.
1. Changed `ios/Runner/Info.plist` after selected Capability.

```
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
    <string>voip</string>
</array>
```

### 2. edit Info.plist

- Edit `ios/Runner/Info.plist` as below.

```
<key>FIVKIconName</key>
<string>AppIcon-VoIPKit</string>
<key>FIVKLocalizedName</key>
<string>VoIP-Kit</string>
<key>FIVKSupportVideo</key>
<true/>
<key>FIVKSkipRecallScreen</key>
<true/>
```

### 3. add New Image set for CallKit

- Add an icon（.png or .pdf） `ios/Runner/Assets.xcassets/AppIcon-VoIPKit` to use on the screen when a call comes in while locked iPhone.

### 4. create VoIP Services Certificate

- Visit the Apple Developer https://developer.apple.com/certificates and create a new VoIP Services Certificate(`.cer`). [Check Voice Over IP (VoIP) Best Practices Figure 11-2 for more information](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/OptimizeVoIP.html).
- Create `.p12` from `.cer` with KeyChainAccess, and `.pem` with openssl.

Create `.p12` from `.cer` with KeyChainAccess |
:-: |
<img src=https://user-images.githubusercontent.com/6649643/88076945-aa9a9d00-cbb5-11ea-9309-5f7f7df8d3b5.png width=520/> |

```
openssl pkcs12 -in voip_services.p12 -out voip_services.pem -nodes -clcerts
```

### 5. request VoIP notification APNs from your server

- See Apple document.
- https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns
- Add data(payload) like a below.

```
{
    "aps": {
        "alert": {
          "uuid": <Version 4 UUID (e.g.: https://www.uuidgenerator.net/version4) >,
          "incoming_caller_id": <your service user id>,
          "incoming_caller_name": <your service user name>,
        }
    }
}
```

- You can use curl to test VoIP notifications as follows.

```
curl -v \
-d '{"aps":{"alert":{"uuid":"982cf533-7b1b-4cf6-a6e0-004aab68c503","incoming_caller_id":"0123456789","incoming_caller_name":"Tester","videoType":true}}}' \
-H "apns-push-type: voip" \
-H "apns-expiration: 0" \
-H "apns-priority: 0" \
-H "apns-topic: <your app’s bundle ID>.voip" \
--http2 \
--cert ./voip_services.pem \
https://api.sandbox.push.apple.com/3/device/<VoIP device Token for your iPhone>
```
# ios_callkit

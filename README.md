<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# twitter_auth_v2

[![pub package](https://img.shields.io/pub/v/twitter_auth_v2.svg)](https://pub.dev/packages/twitter_auth_v2) 
[![likes](https://img.shields.io/pub/likes/twitter_auth_v2?logo=dart)](https://pub.dev/packages/twitter_auth_v2/score) 
[![popularity](https://img.shields.io/pub/popularity/twitter_auth_v2?logo=dart)](https://pub.dev/packages/twitter_auth_v2/score) 
[![pub points](https://img.shields.io/pub/points/twitter_auth_v2?logo=dart)](https://pub.dev/packages/twitter_auth_v2/score)

Flutter package for twitter authentication. [twitter_auth_v2](https://pub.dev/packages/twitter_auth_v2) 

## Twitter Configuration

- Create twitter app [documentation](https://developer.twitter.com)
- Add callback url
    ```
    app://example
    ```

## Android Configuration

Add intent as follows:

```xml
    <intent-filter>
      <action android:name="android.intent.action.VIEW" />
      <category android:name="android.intent.category.DEFAULT" />
      <category android:name="android.intent.category.BROWSABLE" />
      <!-- Accept redirect url like "app://example" -->
      <data android:scheme="app"
            android:host="example" />
    </intent-filter>
```

## IOS Configuration

Change Info.plist as follows

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string></string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>app</string>
    </array>
  </dict>
</array>
```

## Usage

To use this plugin, add `twitter_auth_v2` as a [dependency in your pubspec.yaml file.](https://flutter.dev/platform-plugins/) 

```dart
void _authentication() async {
    final TwitterAuthClient client = TwitterAuthClient(
        callbackUrlScheme: '[CALLBACK_SCHEME]',
        clientId: '[CLIENT_ID]',
        clientSecret: '[CLIENT_SECRET]',
        navigatorKey: navigatorKey,
        loader: const Center(
          child: CircularProgressIndicator(),
        ),
        redirectUri: '[REDIRECT_URI]');
    TwitterAuthResult? data = await client.login(scopes: TwitterScope.values);
    if (data == null) return;
    setState(() {
      _token = data.accessToken;
      _refreshToken = data.refreshToken;
      _expireIn = data.expiresIn.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Access Token: $_token',
            ),
            Text(
              'Refresh Token: $_refreshToken',
            ),
            Text(
              'Expire In: $_expireIn',
            ),
            ElevatedButton(
                onPressed: _authentication, child: const Text('Authentication'))
          ],
        ),
      ),
    );
  }
```

## Licence
   [MIT](https://github.com/JenishMS/twitter_auth_v2/blob/master/LICENSE)
   

Contributions of any kind are welcome!

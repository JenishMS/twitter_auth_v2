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

# Twitter Authentication

Twitter v2 authentication

## Usage

to `/example` folder.

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
    TwitterAuthResult? data = await client.login(scopes: Scope.values);
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

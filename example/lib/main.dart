import 'package:flutter/material.dart';
import 'package:twitter_auth_v2/twitter_auth_v2.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twitter Authentication Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _token = '';
  String _refreshToken = '';
  String _expireIn = '';

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
}

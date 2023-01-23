import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:twitter_auth_v2/src/twitter_scope.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import 'twitter_auth_result.dart';

class TwitterAuthClient {
  final String redirectUri;
  final String clientId;
  final String callbackUrlScheme;
  final String clientSecret;
  final String? userAgent;
  final GlobalKey<NavigatorState> navigatorKey;
  String redirectedUri = '';
  final Widget loader;

  TwitterAuthClient(
      {required this.clientId,
      required this.redirectUri,
      required this.callbackUrlScheme,
      required this.clientSecret,
      required this.navigatorKey,
      this.loader = const SizedBox(),
      this.userAgent});

  Future<TwitterAuthResult?> login({required List<TwitterScope> scopes}) async {
    final String codeVerifier = _generateSecureAlphaNumeric(80);
    final String codeChallenge = _generateCodeChallenge(codeVerifier);

    final Map<String, String> response =
        await _requestCode(scopes: scopes, codeChallenge: codeChallenge);

    return await _requestAccessToken(
      code: response['code']!,
      scopes: scopes,
      codeVerifier: codeVerifier,
    );
  }

  Future<Map<String, String>> _requestCode(
      {required List<TwitterScope> scopes,
      required String codeChallenge}) async {
    final String state = _generateSecureAlphaNumeric(25);
    Uri requestUri = Uri.https(
      'twitter.com',
      '/i/oauth2/authorize',
      {
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scopes.map((scope) => scope.value).join(' '),
        'state': state,
        'code_challenge': codeChallenge,
        'code_challenge_method': 'S256'
      },
    );

    var webView = WebView(
      initialUrl: 'https://twitter.com/i/oauth2/authorize?${requestUri.query}',
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: _navigationDelegate,
      backgroundColor: Colors.transparent,
      userAgent: userAgent,
    );

    await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Stack(
            children: [loader, webView],
          ),
        ),
      ),
    );

    final queryParameters = Uri.parse(redirectedUri).queryParameters;

    if (queryParameters.containsKey('error')) {
      throw Exception(queryParameters['error_description'] ?? '');
    }

    if (queryParameters['state'] != state) {
      throw Exception('User cancelled.');
    }

    return {
      'code': queryParameters['code']!,
      'state': queryParameters['state']!,
    };
  }

  FutureOr<NavigationDecision> _navigationDelegate(NavigationRequest request) {
    var uri = Uri.parse(request.url);
    var redirectUri = Uri.parse(callbackUrlScheme);

    if (uri.queryParameters['error'] != null) {
      _closeWebView();
    }

    var checkHost = uri.host == redirectUri.host;

    if (uri.queryParameters['code'] != null && checkHost) {
      redirectedUri = request.url;
      _closeWebView();
    }
    return NavigationDecision.navigate;
  }

  @override
  Future<Map<String, dynamic>> refreshAccessToken(
    final String refreshToken,
  ) async {
    final response = await http.post(
      Uri.https('api.twitter.com', '/2/oauth2/token'),
      headers: _buildAuthorizationHeader(
        clientId: clientId,
        clientSecret: clientSecret,
      ),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    return jsonDecode(response.body);
  }

  _closeWebView() => navigatorKey.currentState!.pop();

  Future<TwitterAuthResult?> _requestAccessToken({
    required List<TwitterScope> scopes,
    required String code,
    required String codeVerifier,
  }) async {
    final response = await http.post(
      Uri.https('api.twitter.com', '/2/oauth2/token'),
      headers: _buildAuthorizationHeader(
        clientId: clientId,
        clientSecret: clientSecret,
      ),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
        'code_verifier': codeVerifier,
      },
    );

    Map<String, dynamic> tokenData = jsonDecode(response.body);

    return TwitterAuthResult(tokenData['access_token'],
        tokenData['refresh_token'], tokenData['expires_in']);
  }

  String _generateSecureAlphaNumeric(final int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(255));

    return base64UrlEncode(values);
  }

  String _generateCodeChallenge(String codeVerifier) {
    final digest = sha256.convert(utf8.encode(codeVerifier));
    final codeChallenge = base64UrlEncode(digest.bytes);
    if (codeChallenge.endsWith('=')) {
      return codeChallenge.substring(0, codeChallenge.length - 1);
    }
    return codeChallenge;
  }

  Map<String, String> _buildAuthorizationHeader({
    required String clientId,
    required String clientSecret,
  }) {
    final credentials = base64.encode(utf8.encode('$clientId:$clientSecret'));

    return {'Authorization': 'Basic $credentials'};
  }
}

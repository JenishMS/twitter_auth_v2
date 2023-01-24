class TwitterAuthResult {
  TwitterAuthResult(
    this.accessToken,
    this.refreshToken,
    int expireAt,
  ) : expiresIn = DateTime.now()
            .add(Duration(seconds: expireAt))
            .millisecondsSinceEpoch;

  final String accessToken;

  final String refreshToken;

  final int expiresIn;
}

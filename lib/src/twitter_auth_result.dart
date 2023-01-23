class TwitterAuthResult {
  TwitterAuthResult(this.accessToken, this.refreshToken, this.expiresIn);

  final String accessToken;

  final String refreshToken;

  final int expiresIn;
}

enum TwitterScope {
  tweetRead('tweet.read'),
  tweetWrite('tweet.write'),
  tweetModerateWrite('tweet.moderate.write'),
  usersRead('users.read'),
  followsRead('follows.read'),
  followsWrite('follows.write'),
  offlineAccess('offline.access'),
  spaceRead('space.read'),
  muteRead('mute.read'),
  muteWrite('mute.write'),
  likeRead('like.read'),
  likeWrite('like.write'),
  listRead('list.read'),
  listWrite('list.write'),
  blockRead('block.read'),
  blockWrite('block.write'),
  bookmarkRead('bookmark.read'),
  bookmarkWrite('bookmark.write'),
  directMessageRead('dm.read'),
  directMessageWrite('dm.write');

  final String value;

  const TwitterScope(this.value);

  static TwitterScope valueOf(final String value) {
    for (final scope in values) {
      if (scope.value == value) {
        return scope;
      }
    }
    throw ArgumentError('Invalid twitter scope: $value');
  }
}

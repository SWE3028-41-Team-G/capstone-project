class UserInfo {
  final int userId;
  final String username;
  final String nickname;
  final String profileImgUrl;

  UserInfo({
    required this.userId,
    required this.username,
    required this.nickname,
    required this.profileImgUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] as int,
      username: json['username'],
      nickname: json['nickname'],
      profileImgUrl: json['profileImgUrl'],
    );
  }
}

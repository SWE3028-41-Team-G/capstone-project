class UserInfo {
  final int userId;
  final String nickname;
  final String profileImgUrl;

  UserInfo({
    required this.userId,
    required this.nickname,
    required this.profileImgUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'] as int,
      nickname: json['nickname'],
      profileImgUrl: json['profileImgUrl'],
    );
  }
}

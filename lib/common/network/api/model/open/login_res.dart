class LoginRes {
  LoginRes({
    required this.userId,
    required this.token,
  });

  final int userId;
  final String token;

  factory LoginRes.fromJson(Map<String, dynamic> json) {
    return LoginRes(
      userId: json["userId"] ?? 0,
      token: json["token"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "token": token,
      };
}

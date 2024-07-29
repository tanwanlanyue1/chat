class BindingRes {
  BindingRes({
    required this.phone,
    required this.email,
    required this.isWx,
    required this.isApple,
  });

  final String phone; // 用户手机号，带星隐藏
  final String email; // 用户邮箱，带星隐藏
  final bool isWx; // 用户是否绑定微信号 true:绑定 false:未绑定
  final bool isApple; // 用户是否绑定苹果id true:绑定 false:未绑定

  factory BindingRes.fromJson(Map<String, dynamic> json) {
    return BindingRes(
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      isWx: json["isWx"] ?? false,
      isApple: json["isApple"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "email": email,
        "isWx": isWx,
        "isApple": isApple,
      };
}

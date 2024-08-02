/// 用户性别类型
enum UserGender {
  unknown,
  male,
  female;

  static UserGender valueForIndex(int index) {
    return UserGender.values.elementAtOrNull(index) ?? UserGender.female;
  }
}

/// 用户类型
enum UserType {
  user,
  beauty,
  agent;

  static UserType valueForIndex(int index) {
    return UserType.values.elementAtOrNull(index) ?? UserType.user;
  }

  bool get isUser => this == UserType.user;
  bool get isBeauty => this == UserType.beauty;
  bool get isAgent => this == UserType.agent;

}

class UserModel {
  UserModel({
    required this.uid,
    required this.chatNo,
    required this.type,
    required this.state,
    required this.avatar,
    required this.serviceCharge,
    required this.nickname,
    required this.signature,
    // required this.images,
    required this.gender,
    required this.zodiac,
    required this.star,
    required this.birth,
    required this.age,
    required this.position,
    required this.email,
    required this.phone,
    required this.occupation,
    required this.style,
    required this.likeSex,
    required this.likeAgeMin,
    required this.likeAgeMax,
    required this.likeOccupation,
    required this.likeStyle,
  });

  final int uid; // 用户id
  final int chatNo; // 用户编号
  UserType type; // 用户类型 0普通用户 1佳丽 2经纪人
  int state; // 在线状态 0不接约 1接约中 2约会进行中
  String? avatar; // 头像
  final int serviceCharge; // 服务费
  String? nickname; // 昵称
  String? signature; // 个性签名
  // String? images; // 个人图片
  UserGender gender; // 用户性别 1：男 2：女
  String? zodiac; // 生肖
  String? star; // 星座
  String? birth; // 生日yyyy-MM-dd
  int? age; // 年龄
  String? position; // 位置
  String? email; // 邮箱
  String? phone; // 联系电话
  final int occupation; // 职业 1在职人员 2学生
  final String style; // 风格
  final UserGender likeSex; // 喜好性别 0：其它 1：男 2：女
  final int likeAgeMin; // 最小喜好年龄
  final int likeAgeMax; // 最大喜好年龄
  final int likeOccupation; // 喜好职业 1在职人员 2学生
  final String likeStyle; // 喜好风格

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"] ?? 0,
      chatNo: json["chatNo"] ?? 0,
      type: UserType.valueForIndex(json["type"] ?? 0),
      state: json["state"] ?? 0,
      avatar: json["avatar"],
      serviceCharge: json["serviceCharge"] ?? 0,
      nickname: json["nickname"] ?? "",
      signature: json["signature"],
      // images: json["images"],
      gender: UserGender.valueForIndex(json["gender"] ?? 0),
      zodiac: json["zodiac"],
      star: json["star"],
      birth: json["birth"],
      age: json["age"] ?? 0,
      position: json["position"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      occupation: json["occupation"] ?? 0,
      style: json["style"] ?? "",
      likeSex: UserGender.valueForIndex(json["likeSex"] ?? 0),
      likeAgeMin: json["likeAgeMin"] ?? 0,
      likeAgeMax: json["likeAgeMax"] ?? 0,
      likeOccupation: json["likeOccupation"] ?? 0,
      likeStyle: json["likeStyle"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "chatNo": chatNo,
        "type": type.index,
        "state": state,
        "avatar": avatar,
        "serviceCharge": serviceCharge,
        "nickname": nickname,
        "signature": signature,
        // "images": String.toJson(),
        "gender": gender.index,
        "zodiac": zodiac,
        "star": star,
        "birth": birth,
        "age": age,
        "position": position,
        "email": email,
        "phone": phone,
        "occupation": occupation,
        "style": style,
        "likeSex": likeSex.index,
        "likeAgeMin": likeAgeMin,
        "likeAgeMax": likeAgeMax,
        "likeOccupation": likeOccupation,
        "likeStyle": likeStyle,
      };
}

/// 用户性别类型
enum UserGender {
  unknown,
  male,
  female;

  static UserGender valueForIndex(int index) {
    return UserGender.values.elementAtOrNull(index) ?? UserGender.unknown;
  }

  bool get isMale => this == UserGender.male;
  bool get isFemale => this == UserGender.female;

  String? get icon {
    switch (this) {
      case male:
        return 'assets/images/mine/man.png';
      case female:
        return 'assets/images/mine/woman.png';
      default:
        return null;
    }
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

/// 用户状态
enum UserStatus {
  offline, // 下线(不接单) 0
  online, // 上线（接单中）1
  inProgress; // 约会中 2

  static UserStatus valueForIndex(int index) {
    return UserStatus.values.elementAtOrNull(index) ?? UserStatus.offline;
  }
}

/// 用户职业
enum UserOccupation {
  unknown,
  employees,
  student;

  static UserOccupation valueForIndex(int index) {
    return UserOccupation.values.elementAtOrNull(index) ??
        UserOccupation.unknown;
  }
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
    required this.images,
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
    this.praiseRate,
    this.dealNum,
    this.payPwd,
    required this.balance,
    required this.withdrawals,
    required this.withdrawalsAble,
    required this.vip,
    required this.expirationTime,
  });

  final int uid; // 用户id
  final int chatNo; // 用户编号
  UserType type; // 用户类型 0普通用户 1佳丽 2经纪人
  UserStatus state; // 在线状态 0不接约 1接约中 2约会进行中
  String? avatar; // 头像
  double serviceCharge; // 服务费
  String nickname; // 昵称
  String? signature; // 个性签名
  String? images; // 个人图片 "1, 2, 4" 逗号隔开
  UserGender gender; // 用户性别 1：男 2：女
  String? zodiac; // 生肖
  String? star; // 星座
  int? birth; // 生日yyyy-MM-dd
  int? age; // 年龄
  String? position; // 位置
  String? email; // 邮箱
  String? phone; // 联系电话
  UserOccupation occupation; // 职业 1在职人员 2学生
  String? style; // 风格
  UserGender likeSex; // 喜好性别 0：其它 1：男 2：女
  int likeAgeMin; // 最小喜好年龄
  int likeAgeMax; // 最大喜好年龄
  UserOccupation likeOccupation; // 喜好职业 1在职人员 2学生
  String? likeStyle; // 喜好风格 "1, 2, 4" 逗号隔开
  String? praiseRate; // 	好评率
  int? dealNum; // 成交单数 30天内的
  bool? payPwd; // 是否设置支付密码 true已设置 false未设置
  num balance = 0; //余额
  bool vip; // 是否为VIP
  int expirationTime; // VIP到期时间
  ///钱包历史提现金额
  num withdrawals = 0;
  ///	钱包可提现金额
  num withdrawalsAble = 0;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"] ?? 0,
      chatNo: json["chatNo"] ?? 0,
      type: UserType.valueForIndex(json["type"] ?? 0),
      state: UserStatus.valueForIndex(json["state"] ?? 0),
      avatar: json["avatar"] ?? "",
      serviceCharge: json["serviceCharge"] ?? 0,
      nickname: json["nickname"] ?? "",
      signature: json["signature"],
      images: json["images"],
      gender: UserGender.valueForIndex(json["gender"] ?? 0),
      zodiac: json["zodiac"],
      star: json["star"],
      birth: json["birth"],
      age: json["age"],
      position: json["position"],
      email: json["email"],
      phone: json["phone"],
      occupation: UserOccupation.valueForIndex(json["occupation"] ?? 0),
      style: json["style"],
      likeSex: UserGender.valueForIndex(json["likeSex"] ?? 0),
      likeAgeMin: json["likeAgeMin"] ?? 18,
      likeAgeMax: json["likeAgeMax"] ?? 40,
      likeOccupation: UserOccupation.valueForIndex(json["likeOccupation"] ?? 0),
      likeStyle: json["likeStyle"],
      praiseRate: json["praiseRate"],
      dealNum: json["dealNum"],
      payPwd: json["payPwd"] ?? false,
      balance: json["balance"] ?? 0,
      withdrawalsAble: json["withdrawalsAble"] ?? 0,
      withdrawals: json["withdrawals"] ?? 0,
      vip: json["vip"] ?? false,
      expirationTime: json["expirationTime"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "chatNo": chatNo,
        "type": type.index,
        "state": state.index,
        "avatar": avatar,
        "serviceCharge": serviceCharge,
        "nickname": nickname,
        "signature": signature,
        "images": images,
        "gender": gender.index,
        "zodiac": zodiac,
        "star": star,
        "birth": birth,
        "age": age,
        "position": position,
        "email": email,
        "phone": phone,
        "occupation": occupation.index,
        "style": style,
        "likeSex": likeSex.index,
        "likeAgeMin": likeAgeMin,
        "likeAgeMax": likeAgeMax,
        "likeOccupation": likeOccupation.index,
        "likeStyle": likeStyle,
        "praiseRate": praiseRate,
        "dealNum": dealNum,
        "payPwd": payPwd,
        "vip": vip,
        "expirationTime": expirationTime,
        "balance": balance,
        "withdrawalsAble": withdrawalsAble,
        "withdrawals": withdrawals,
      };

  UserModel copyWith({
    int? uid,
    int? chatNo,
    UserType? type,
    UserStatus? state,
    String? avatar,
    double? serviceCharge,
    String? nickname,
    String? signature,
    String? images,
    UserGender? gender,
    String? zodiac,
    String? star,
    int? birth,
    int? age,
    String? position,
    String? email,
    String? phone,
    UserOccupation? occupation,
    String? style,
    UserGender? likeSex,
    int? likeAgeMin,
    int? likeAgeMax,
    UserOccupation? likeOccupation,
    String? likeStyle,
    String? praiseRate,
    int? dealNum,
    bool? payPwd,
    num? balance,
    num? withdrawals,
    num? withdrawalsAble,
    bool? vip,
    int? expirationTime,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      chatNo: chatNo ?? this.chatNo,
      type: type ?? this.type,
      state: state ?? this.state,
      avatar: avatar ?? this.avatar,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      nickname: nickname ?? this.nickname,
      signature: signature ?? this.signature,
      images: images ?? this.images,
      gender: gender ?? this.gender,
      zodiac: zodiac ?? this.zodiac,
      star: star ?? this.star,
      birth: birth ?? this.birth,
      age: age ?? this.age,
      position: position ?? this.position,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      occupation: occupation ?? this.occupation,
      style: style ?? this.style,
      likeSex: likeSex ?? this.likeSex,
      likeAgeMin: likeAgeMin ?? this.likeAgeMin,
      likeAgeMax: likeAgeMax ?? this.likeAgeMax,
      likeOccupation: likeOccupation ?? this.likeOccupation,
      likeStyle: likeStyle ?? this.likeStyle,
      praiseRate: praiseRate ?? this.praiseRate,
      dealNum: dealNum ?? this.dealNum,
      payPwd: payPwd ?? this.payPwd,
      balance: balance ?? this.balance,
      withdrawals: withdrawals ?? this.withdrawals,
      withdrawalsAble: withdrawalsAble ?? this.withdrawalsAble,
      vip: vip ?? this.vip,
      expirationTime: expirationTime ?? this.expirationTime,
    );
  }
}

class ArchivesInfo {
  ArchivesInfo({
    this.id,
    this.sex = 0,
    this.avatar,
    this.nickname,
    this.label,
    this.birth,
    this.birthPlace,
    this.currentResidence,
    this.timeZone,
  });

  int? id; // id
  int sex; // 性别 0：男， 1： 女
  String? avatar; // 头像
  String? nickname; // 昵称
  String? label; // 档案标签
  String? birth; // 生日String（因为有未知）
  String? birthPlace; // 出生地点
  String? currentResidence; // 现居地
  String? timeZone; // 时区

  ArchivesInfo copyWith({
    int? id,
    int? sex,
    String? avatar,
    String? nickname,
    String? label,
    String? birth,
    String? birthPlace,
    String? currentResidence,
    String? timeZone,
  }) {
    return ArchivesInfo(
      id: id ?? this.id,
      sex: sex ?? this.sex,
      avatar: avatar ?? this.avatar,
      nickname: nickname ?? this.nickname,
      label: label ?? this.label,
      birth: birth ?? this.birth,
      birthPlace: birthPlace ?? this.birthPlace,
      currentResidence: currentResidence ?? this.currentResidence,
      timeZone: timeZone ?? this.timeZone,
    );
  }

  factory ArchivesInfo.fromJson(Map<String, dynamic> json) {
    return ArchivesInfo(
      id: json["id"] ?? 0,
      sex: json["sex"] ?? 0,
      avatar: json["avatar"] ?? "",
      nickname: json["nickname"] ?? "",
      label: json["label"] ?? "",
      birth: json["birth"] ?? "",
      birthPlace: json["birthPlace"] ?? "",
      currentResidence: json["currentResidence"] ?? "",
      timeZone: json["timeZone"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "nickname": nickname,
        "label": label,
        "birth": birth,
        "birthPlace": birthPlace,
        "currentResidence": currentResidence,
        "timeZone": timeZone,
        "sex": sex,
      };
}

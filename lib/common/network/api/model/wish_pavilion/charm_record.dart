/// 符文记录
class CharmRecord {
  CharmRecord({
    required this.id,
    required this.giftId,
    required this.getLight,
    required this.getBless,
    required this.lightStatus,
    required this.blessStatus,
    required this.extraJson,
    required this.name,
    required this.remark,
    required this.lightCount,
    required this.blessCount,
    required this.count,
    required this.isGetMav,
  });

  final int id; // id
  final int giftId; // 灵符id
  final int getLight; // 获得开光次数
  final int getBless; // 获得加持次数
  final int lightStatus; // 开光状态 0未开光 1已开光
  final int blessStatus; // 加持状态 0未加持 1已加持
  final CharmImgList? extraJson; // 灵符图片集（所有状态的图片）
  final String name; // 灵符名称
  final String remark; // 灵符描述
  final int lightCount; // 当前用户剩余开光次数
  final int blessCount; // 当前用户剩余加持次数
  final int count; // 当前状态的此灵符数量
  final int isGetMav; // 当前灵符是否已经领取功德 0未领取 1已领取

  /// 获取最完美状态的图片url
  String get perfectImageUrl => extraJson?.image3 ?? "";

  /// 获取当前状态图片url
  String get currentStateImageUrl {
    final isLight = lightStatus == 1;
    final isBless = blessStatus == 1;

    String imageUrl = "";
    if (!isLight && !isBless) {
      imageUrl = extraJson?.image1 ?? "";
    } else if (isLight && isBless) {
      imageUrl = extraJson?.image3 ?? "";
    } else {
      imageUrl = extraJson?.image2 ?? "";
    }
    return imageUrl;
  }

  factory CharmRecord.fromJson(Map<String, dynamic> json) {
    return CharmRecord(
      id: json["id"] ?? 0,
      giftId: json["giftId"] ?? 0,
      getLight: json["getLight"] ?? 0,
      getBless: json["getBless"] ?? 0,
      lightStatus: json["lightStatus"] ?? 0,
      blessStatus: json["blessStatus"] ?? 0,
      extraJson: json["extraJson"] == null
          ? null
          : CharmImgList.fromJson(json["extraJson"]),
      name: json["name"] ?? "",
      remark: json["remark"] ?? "",
      lightCount: json["lightCount"] ?? 0,
      blessCount: json["blessCount"] ?? 0,
      count: json["count"] ?? 0,
      isGetMav: json["isGetMav"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "giftId": giftId,
        "getLight": getLight,
        "getBless": getBless,
        "lightStatus": lightStatus,
        "blessStatus": blessStatus,
        "extraJson": extraJson?.toJson(),
        "name": name,
        "remark": remark,
        "lightCount": lightCount,
        "blessCount": blessCount,
        "count": count,
        "isGetMav": isGetMav,
      };
}

class CharmImgList {
  CharmImgList({
    required this.image1,
    required this.image2,
    required this.image3,
  });

  final String image1;
  final String image2;
  final String image3;

  factory CharmImgList.fromJson(Map<String, dynamic> json) {
    return CharmImgList(
      image1: json["image1"] ?? "",
      image2: json["image2"] ?? "",
      image3: json["image3"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "image1": image1,
        "image2": image2,
        "image3": image3,
      };
}

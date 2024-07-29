class GiftModel {
  GiftModel({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.subType,
    required this.extraConfig,
    required this.defaultBack,
    required this.remark,
    required this.goldNum,
    required this.svga,
    required this.periodTime,
    required this.mavNum,
    required this.cavNum,
    required this.freeCount,
    required this.surplusCount,
    required this.afterFree,
  });

  final int id; // id
  final String name; // 礼物名称
  final String image; // 礼物图片地址
  final int type; // 礼物类型：1上香2供品，3河灯，4天灯，5供灯
  final int subType; // 子类型：type=4时,1婚恋2生活3学业4财运5事业
  final int extraConfig; // 是否有多种时效配置 0：无 1：有
  final String defaultBack; // 默认文案
  final String remark; // 备注
  final int goldNum; // 境修币价格 0表示免费
  final String svga; // 礼物动效地址
  final int periodTime; // 有效时间（秒）
  final int mavNum; // +功德值
  final int cavNum; // +修行值
  final int freeCount; //	总免费次数
  final int surplusCount; // 剩余免费次数
  final int afterFree; // 免费次数用完之后的价格

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      type: json["type"] ?? 0,
      subType: json["subType"] ?? 0,
      extraConfig: json["extraConfig"] ?? 0,
      defaultBack: json["defaultBack"] ?? "",
      remark: json["remark"] ?? "",
      goldNum: json["goldNum"] ?? 0,
      svga: json["svga"] ?? "",
      periodTime: json["periodTime"] ?? 0,
      mavNum: json["mavNum"] ?? 0,
      cavNum: json["cavNum"] ?? 0,
      freeCount: json["freeCount"] ?? 0,
      surplusCount: json["surplusCount"] ?? 0,
      afterFree: json["afterFree"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "subType": subType,
        "extraConfig": extraConfig,
        "defaultBack": defaultBack,
        "remark": remark,
        "goldNum": goldNum,
        "svga": svga,
        "periodTime": periodTime,
        "mavNum": mavNum,
        "cavNum": cavNum,
        "freeCount": freeCount,
        "surplusCount": surplusCount,
        "afterFree": afterFree,
      };
}

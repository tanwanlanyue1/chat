import 'charm_record.dart';

class CharmRes {
  CharmRes({
    required this.id,
    required this.name,
    required this.image,
    required this.subType,
    required this.remark,
    required this.extraConfig,
    required this.extraJson,
    required this.goldNum,
    required this.isHave,
  });

  final int id; // id
  final String name; // 礼物名称
  final String image; // 礼物图片地址
  final int subType; // 子类型：1佛菩萨 2度母佛母 3本尊护法 4符咒
  final String remark; // 备注
  final int extraConfig; // 热门标志：0否1是
  final CharmImgList? extraJson; // 灵符图片集（所有状态的图片）
  final int goldNum; // 境修币价格 0表示免费
  final int isHave; // 是否拥有 0未拥有 1已拥有

  /// 获取最完美状态的图片url
  String get perfectImageUrl => extraJson?.image3 ?? "";

  factory CharmRes.fromJson(Map<String, dynamic> json) {
    return CharmRes(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      subType: json["subType"] ?? 0,
      remark: json["remark"] ?? "",
      extraConfig: json["extraConfig"] ?? 0,
      extraJson: json["extraJson"] == null
          ? null
          : CharmImgList.fromJson(json["extraJson"]),
      goldNum: json["goldNum"] ?? 0,
      isHave: json["isHave"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "subType": subType,
        "remark": remark,
        "extraConfig": extraConfig,
        "extraJson": extraJson?.toJson(),
        "goldNum": goldNum,
        "isHave": isHave,
      };
}

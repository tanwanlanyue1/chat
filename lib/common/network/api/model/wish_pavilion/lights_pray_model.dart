///供灯祈福
class LightsPrayModel {
  LightsPrayModel({
    required this.id,
    required this.uid,
    required this.giftId,
    required this.lanternImg,
    required this.svga,
    required this.name,
    required this.direction,
    required this.position,
    required this.back,
    required this.open,
    required this.endTime,
    required this.isBless,
    required this.bless,
    required this.blessAvatar,
  });

  final int id; // 供灯记录ID
  final int uid; // 用户ID
  final int giftId; // 灯ID
  final String lanternImg; // 灯图片
  final String svga; // 礼物动效
  final String name; // 姓名
  final int direction; // 供灯方向（0东1南2西3北）
  final int position; // 位置
  final String back; // 回向内容
  final int open; // 是否公开 0：公开 1：不公开
  final String endTime; // 灯结束时间
  final bool isBless; // 是否已阿弥陀佛（点赞）
  final int bless; // 阿弥陀佛人数
  final List<String> blessAvatar; // 最近7位用户阿弥陀佛头像地址

  factory LightsPrayModel.fromJson(Map<String, dynamic> json) {
    return LightsPrayModel(
      id: json["id"] ?? 0,
      uid: json["uid"] ?? 0,
      giftId: json["giftId"] ?? 0,
      lanternImg: json["lanternImg"] ?? "",
      svga: json["svga"] ?? "",
      name: json["name"] ?? "",
      direction: json["direction"] ?? 0,
      position: json["position"] ?? 0,
      back: json["back"] ?? "",
      open: json["open"] ?? 0,
      endTime: json["endTime"] ?? "",
      isBless: json["isBless"] ?? false,
      bless: json["bless"] ?? 0,
      blessAvatar: json["blessAvatar"] == null
          ? []
          : List<String>.from(json["blessAvatar"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "giftId": giftId,
        "lanternImg": lanternImg,
        "svga": svga,
        "name": name,
        "direction": direction,
        "position": position,
        "back": back,
        "open": open,
        "endTime": endTime,
        "isBless": isBless,
        "bless": bless,
        "blessAvatar": blessAvatar.map((x) => x).toList(),
      };
}

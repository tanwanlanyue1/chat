
///佛像供奉的供品信息
class OfferingGiftInfoModel {
  OfferingGiftInfoModel({
    required this.id,
    required this.uid,
    required this.buddhaId,
    required this.giftId,
    required this.direction,
    required this.endTime,
    required this.status,
  });

  ///上供记录ID
  final int id;

  ///用户id
  final int uid;

  ///	佛像ID
  final int buddhaId;

  ///供品ID
  final int giftId;

  ///	上供方向（0左1右, 没有则是香）
  final int? direction;

  ///供品结束时间
  final String endTime;

  ///供品状态 0：正常 1：已结束
  final int status;

  factory OfferingGiftInfoModel.fromJson(Map<String, dynamic> json){
    return OfferingGiftInfoModel(
      id: json["id"] ?? 0,
      uid: json["uid"] ?? 0,
      buddhaId: json["buddhaId"] ?? 0,
      giftId: json["giftId"] ?? 0,
      direction: json["direction"],
      endTime: json["endTime"] ?? "",
      status: json["status"] ?? 0,
    );
  }

}

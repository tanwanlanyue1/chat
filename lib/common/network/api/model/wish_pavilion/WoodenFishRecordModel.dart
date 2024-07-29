
///木鱼诵经记录
class WoodenFishRecordModel {
  WoodenFishRecordModel({
    required this.count,
    required this.list,
  });

  ///今日每一本经书诵读次数统计
  final List<SutrasStatsItem> count;

  ///木鱼诵经记录列表
  final List<WoodenFishRecordItem> list;

  factory WoodenFishRecordModel.fromJson(Map<String, dynamic> json){
    return WoodenFishRecordModel(
      count: json["count"] == null ? [] : List<SutrasStatsItem>.from(json["count"]!.map((x) => SutrasStatsItem.fromJson(x))),
      list: json["list"] == null ? [] : List<WoodenFishRecordItem>.from(json["list"]!.map((x) => WoodenFishRecordItem.fromJson(x))),
    );
  }

}

///	今日每一本经书诵读次数统计
class SutrasStatsItem {
  SutrasStatsItem({
    required this.count,
    required this.giftName,
    required this.endTime,
  });

  ///次数
  final int count;

  ///
  final String giftName;

  final String endTime;

  factory SutrasStatsItem.fromJson(Map<String, dynamic> json){
    return SutrasStatsItem(
      count: json["count"] ?? 0,
      giftName: json["giftName"] ?? "",
      endTime: json["endTime"] ?? "",
    );
  }

}

///木鱼诵经记录项
class WoodenFishRecordItem {
  WoodenFishRecordItem({
    required this.id,
    required this.uid,
    required this.scripturesId,
    required this.completionRate,
    required this.count,
    required this.startTime,
    required this.endTime,
    required this.number,
    required this.name,
  });

  ///ID
  final int id;

  ///用户id
  final int uid;

  ///佛经id
  final int scripturesId;

  ///本次完成度
  final double completionRate;

  ///本次法器敲击次数
  final int count;

  ///	开始时间
  final String startTime;

  ///	结束时间
  final String endTime;

  ///	今日第几次诵此经
  final int number;

  ///佛经名称
  final String name;

  factory WoodenFishRecordItem.fromJson(Map<String, dynamic> json){
    return WoodenFishRecordItem(
      id: json["id"] ?? 0,
      uid: json["uid"] ?? 0,
      scripturesId: json["scripturesId"] ?? 0,
      completionRate: json["completionRate"] ?? 0,
      count: json["count"] ?? 0,
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      number: json["number"] ?? 0,
      name: json["name"] ?? "",
    );
  }

}


///顶礼，供奉记录
class OfferingRecordModel {
  OfferingRecordModel({
    required this.buddhaName,
    required this.buddhaImage,
    required this.recordList,
  });

  ///	佛像名称
  final String buddhaName;

  /// 佛像图片
  final String buddhaImage;

  ///今日礼物记录统计
  final List<OfferingRecordItem> recordList;

  factory OfferingRecordModel.fromJson(Map<String, dynamic> json){
    return OfferingRecordModel(
      buddhaName: json["buddhaName"] ?? "",
      buddhaImage: json["buddhaImage"] ?? "",
      recordList: json["recordList"] == null ? [] : List<OfferingRecordItem>.from(json["recordList"]!.map((x) => OfferingRecordItem.fromJson(x))),
    );
  }

}

class OfferingRecordItem {
  OfferingRecordItem({
    required this.count,
    required this.giftName,
    required this.endTime,
  });

  ///次数
  final int count;

  ///礼物名称
  final String giftName;

  ///结束时间
  final String endTime;

  OfferingRecordItem copyWith({
    int? count,
    String? giftName,
    String? endTime,
  }) {
    return OfferingRecordItem(
      count: count ?? this.count,
      giftName: giftName ?? this.giftName,
      endTime: endTime ?? this.endTime,
    );
  }

  factory OfferingRecordItem.fromJson(Map<String, dynamic> json){
    return OfferingRecordItem(
      count: json["count"] ?? 0,
      giftName: json["giftName"] ?? "",
      endTime: json["endTime"] ?? "",
    );
  }

}

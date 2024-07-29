
///修行记录
class CultivationRecordModel {
  CultivationRecordModel({
    required this.name,
    required this.type,
    required this.time,
    required this.bname,
  });

  ///名称
  final String name;

  ///类型：tribute=上香或供礼，direction=念珠，scriptures=木鱼诵经
  final String type;

  ///时间点
  final String time;

  ///佛像名称
  final String bname;

  factory CultivationRecordModel.fromJson(Map<String, dynamic> json){
    return CultivationRecordModel(
      name: json["name"] ?? "",
      bname: json["bname"] ?? "",
      type: json["type"] ?? "",
      time: json["time"] ?? "",
    );
  }

}

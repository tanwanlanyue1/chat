///念珠记录
class RosaryBeadsRecordModel {
  RosaryBeadsRecordModel({
    required this.id,
    required this.uid,
    required this.startTime,
    required this.endTime,
    required this.count,
  });

  ///ID
  final int id;

  ///	用户id
  final int uid;

  ///	开始时间
  final String startTime;

  ///	结束时间
  final String endTime;

  ///	本次念珠次数
  final int count;

  factory RosaryBeadsRecordModel.fromJson(Map<String, dynamic> json){
    return RosaryBeadsRecordModel(
      id: json["id"] ?? 0,
      uid: json["uid"] ?? 0,
      startTime: json["startTime"] ?? "",
      endTime: json["endTime"] ?? "",
      count: json["count"] ?? 0,
    );
  }

}

///木鱼相关记录
class RecitationRecordModel {
  RecitationRecordModel({
    required this.count,
    required this.list,
  });

  final List<Count> count;
  final List<ListElement> list;

  factory RecitationRecordModel.fromJson(Map<String, dynamic> json){
    return RecitationRecordModel(
      count: json["count"] == null ? [] : List<Count>.from(json["count"]!.map((x) => Count.fromJson(x))),
      list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
    );
  }

}

class Count {
  Count({
    required this.count,
    required this.giftName,
    required this.endTime,
  });

  final int count;
  final String giftName;
  final String endTime;

  factory Count.fromJson(Map<String, dynamic> json){
    return Count(
      count: json["count"] ?? 0,
      giftName: json["giftName"] ?? "",
      endTime: json["endTime"] ?? "",
    );
  }

}

class ListElement {
  ListElement({
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

  final int id;
  final int uid;
  final int scripturesId;
  final int completionRate;
  final int count;
  final String startTime;
  final String endTime;
  final int number;
  final String name;

  factory ListElement.fromJson(Map<String, dynamic> json){
    return ListElement(
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

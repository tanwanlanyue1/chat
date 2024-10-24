
///地区
class AreaModel {
  AreaModel({
    required this.code,
    required this.name,
    required this.level,
  });

  ///编码
  final String code;
  final String name;

  ///级别
  final String level;

  factory AreaModel.fromJson(Map<String, dynamic> json){
    return AreaModel(
      code: json["code"] ?? "",
      name: json["name"] ?? "",
      level: json["level"] ?? "",
    );
  }

}


///禅语
class ZenLanguageModel {
  ZenLanguageModel({
    required this.id,
    required this.title,
    required this.content,
    required this.remark,
  });

  final int id;
  final String title;
  final String content;
  final String remark;

  factory ZenLanguageModel.fromJson(Map<String, dynamic> json){
    return ZenLanguageModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      remark: json["remark"] ?? "",
    );
  }

}

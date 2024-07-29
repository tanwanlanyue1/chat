
///佛像
class BuddhaModel {
  BuddhaModel({
    required this.id,
    required this.name,
    required this.introduce,
    required this.picture,
  });

  ///ID
  final int id;

  ///名称
  final String name;

  ///描述
  final String introduce;

  ///图片
  final String picture;

  factory BuddhaModel.fromJson(Map<String, dynamic> json){
    return BuddhaModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      introduce: json["introduce"] ?? "",
      picture: json["picture"] ?? "",
    );
  }

}

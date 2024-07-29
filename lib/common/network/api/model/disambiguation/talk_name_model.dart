//取名
class TalkNameModel {
  TalkNameModel({
    //名字
      this.name,
    //寓意
      this.implication,});

  TalkNameModel.fromJson(dynamic json) {
    name = json['name'];
    implication = json['implication'];
  }
  String? name;
  String? implication;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['implication'] = implication;
    return map;
  }

}
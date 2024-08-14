//交友大厅-推荐列表

class RecommendModel {
  RecommendModel({
      this.uid, 
      this.type, 
      this.avatar, 
      this.nickname, 
      this.images, 
      this.gender, 
      this.age, 
      this.style, 
      this.distance,});

  RecommendModel.fromJson(dynamic json) {
    uid = json['uid'];
    type = json['type'];
    avatar = json['avatar'];
    nickname = json['nickname'];
    images = json['images'];
    gender = json['gender'];
    age = json['age'];
    style = json['style'];
    distance = json['distance'];
  }
  int? uid;
  int? type;
  String? avatar;
  String? nickname;
  dynamic images;
  int? gender;
  int? age;
  String? style;
  String? distance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['type'] = type;
    map['avatar'] = avatar;
    map['nickname'] = nickname;
    map['images'] = images;
    map['gender'] = gender;
    map['age'] = age;
    map['style'] = style;
    map['distance'] = distance;
    return map;
  }

}
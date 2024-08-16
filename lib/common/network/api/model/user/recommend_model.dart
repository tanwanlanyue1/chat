//交友大厅-推荐列表

class RecommendModel {
  RecommendModel({
    this.uid,
    //用户类型 0普通用户 1佳丽 2经纪人
    this.type,
    //头像
    this.avatar,
    //	昵称
    this.nickname,
    //	个人图片
    this.images,
    //	用户性别 0：保密 1：男 2：女
    this.gender,
    //	年龄
    this.age,
    //风格
    this.style,
    //	距离 km
    this.distance,
    //	坐标 经纬度用英文逗号隔开
    this.location,
  });

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
    location = json['location'];
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
  String? location;

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
    map['location'] = location;
    return map;
  }

}
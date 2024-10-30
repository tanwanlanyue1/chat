//交友大厅-推荐列表

import 'package:guanjia/common/network/api/model/open/app_config_model.dart';

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
    //vip图标
    this.nameplate,
    //风格图标
    this.styleList,
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
    nameplate = json['nameplate'];
    if (json['styleList'] != null) {
      styleList = [];
      json['styleList'].forEach((v) {
        styleList?.add(LabelModel.fromJson(v));
      });
    }
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
  String? nameplate;
  List<LabelModel>? styleList;

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
    map['nameplate'] = nameplate;
    if (map['styleList'] != null) {
      styleList = [];
      map['styleList'].forEach((v) {
        styleList?.add(LabelModel.fromJson(v));
      });
    }
    return map;
  }

}
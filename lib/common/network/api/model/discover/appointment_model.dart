import '../../api.dart';

class AppointmentModel {
  AppointmentModel({
      this.id, 
      this.uid, 
      this.type, 
      this.content, 
      this.location, 
      this.startTime, 
      this.endTime, 
      this.tag, 
      this.distance,
      this.coordinate,
      this.serviceCharge,
      this.createTime, 
      this.userInfo,});

  AppointmentModel.fromJson(dynamic json) {
    id = json['id'];
    uid = json['uid'];
    type = json['type'];
    content = json['content'];
    location = json['location'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    coordinate = json['coordinate'];
    tag = json['tag'];
    distance = json['distance'];
    serviceCharge = json['serviceCharge'];
    createTime = json['createTime'];
    userInfo = json['userInfo'] != null ? UserModel.fromJson(json['userInfo']) : null;
  }
  int? id;
  //发起人id
  int? uid;
  //约会类型 1边玩边吃 2同城周边 3双飞国外 4海上游轮 5自驾游 6商务陪游 7饭局宴席
  int? type;
  //	约会内容介绍
  String? content;
  //	约会地点
  String? location;
  //	约会开始时间
  int? startTime;
  //约会结束时间
  int? endTime;
  //	附加标签
  String? tag;
  //经纬度
  String? coordinate;
  //距离
  double? distance;
  //服务费
  double? serviceCharge;
  //	创建时间
  int? createTime;
  UserModel? userInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uid'] = uid;
    map['type'] = type;
    map['content'] = content;
    map['location'] = location;
    map['startTime'] = startTime;
    map['endTime'] = endTime;
    map['tag'] = tag;
    map['coordinate'] = coordinate;
    map['distance'] = distance;
    map['serviceCharge'] = serviceCharge;
    map['createTime'] = createTime;
    if (userInfo != null) {
      map['userInfo'] = userInfo?.toJson();
    }
    return map;
  }

}

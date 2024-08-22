import 'package:guanjia/common/network/api/api.dart';

///音视频速配 应用内消息内容
class CallMatchContent {

  ///1视频速配, 2语音速配
  final int type;

  ///发起人ID
  final int uid;

  ///发起人昵称
  final String nickname;

  ///发起人头像
  final String avatar;

  ///发起人性别
  final UserGender gender;

  ///订单ID
  final int orderId;

  ///过期时间
  final int expiredTime;

  ///年龄
  final int? age;

  ///是否是视频
  bool get isVideo => type == 1;

  CallMatchContent({
    required this.type,
    required this.uid,
    required this.nickname,
    required this.avatar,
    required this.gender,
    required this.orderId,
    required this.expiredTime,
    required this.age,
  });

  factory CallMatchContent.fromJson(Map<String, dynamic> json) {
    final genderVal = json['gender'] ?? 0;

    return CallMatchContent(
      type: json['type'] ?? 0,
      uid: json['uid'] ?? 0,
      nickname: json['nickname'] ?? '',
      avatar: json['avatar'] ?? '',
      gender: UserGender.valueForIndex(genderVal),
      orderId: json['orderId'] ?? 0,
      expiredTime: json['expiredTime'] ?? 0,
      age: json['age'],
    );
  }
}

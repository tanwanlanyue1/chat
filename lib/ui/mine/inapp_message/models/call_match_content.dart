import 'package:guanjia/common/network/api/api.dart';

///音视频速配消息内容
class CallMatchContent {
  ///是否是视频速配
  final bool isVideoMatch;

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

  CallMatchContent({
    required this.isVideoMatch,
    required this.uid,
    required this.nickname,
    required this.avatar,
    required this.gender,
    required this.orderId,
    required this.expiredTime,
  });

  factory CallMatchContent.fromJson(Map<String, dynamic> json) {
    final genderVal = json['gender'] ?? 0;

    return CallMatchContent(
      isVideoMatch: json['isVideoMatch'] ?? false,
      uid: json['uid'] ?? 0,
      nickname: json['nickname'] ?? '',
      avatar: json['avatar'] ?? '',
      gender: UserGender.valueForIndex(genderVal),
      orderId: json['orderId'] ?? 0,
      expiredTime: json['expiredTime'] ?? 0,
    );
  }
}

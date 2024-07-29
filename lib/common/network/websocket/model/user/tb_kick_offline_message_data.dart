
///用户被踢下线数据
class TBKickOfflineMessageData {
  ///1 同一用户登录踢下线, 2后台踢下线, 3修改密码踢下线
  final int type;

  ///被踢时间
  final String? createTime;

  ///设备类型
  final String? deviceType;

  ///登录方式 1.QQ 2.微信 3.苹果 4.google 5.faceBook 6.密码登录 7.验证码登录 8.邮箱登录 9.H5登录
  final int? loginType;

  TBKickOfflineMessageData({
    required this.type,
    this.createTime,
    this.deviceType,
    this.loginType,
  });

  factory TBKickOfflineMessageData.fromJson(Map<String, dynamic> json){
    return TBKickOfflineMessageData(
      type: json['type'] as int,
      createTime: json['createTime'] as String?,
      deviceType: json['deviceType'] as String?,
      loginType: json['loginType'] as int?,
    );
  }
}

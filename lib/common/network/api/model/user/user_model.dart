import 'package:guanjia/common/extension/list_extension.dart';

enum UserAttentionStatus {
  notFollowing("关注"), // 未关注
  following("已关注"), // 已关注
  mutual("互关"), // 互关
  unknown("未知"); // 未知

  const UserAttentionStatus(this.title);

  final String title;

  static UserAttentionStatus valueForIndex(int index) {
    return UserAttentionStatus.values.safeElementAt(index) ??
        UserAttentionStatus.unknown;
  }
}

class UserModel {
  UserModel({
    required this.uid,
    required this.chatNo,
    required this.avatar,
    required this.nickname,
    required this.signature,
    required this.gender,
    required this.zodiac,
    required this.star,
    required this.birth,
    required this.creationNum,
    required this.fansNum,
    required this.mutualFollow,
    required this.cavLevel,
  });

  final int uid; // 用户id
  final int chatNo; // 账号id
  String? avatar; // 头像
  String? nickname; // 昵称
  String? signature; // 个性签名
  int? gender; // 用户性别 0：保密 1：男 2：女
  String? zodiac; // 生肖
  String? star; // 星座
  String? birth; // 生日yyyy-MM-dd

  /// 下面参数供关注或粉丝列表使用
  int creationNum; // 创作数
  int fansNum; // 粉丝数
  UserAttentionStatus mutualFollow; // 是否互关 0-未关注，1-关注，2-互关
  int cavLevel; // 修行等级

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"] ?? 0,
      chatNo: json["chatNo"] ?? 0,
      avatar: json["avatar"],
      nickname: json["nickname"],
      signature: json["signature"],
      gender: json["gender"],
      zodiac: json["zodiac"],
      star: json["star"],
      birth: json["birth"],
      creationNum: json["creationNum"] ?? 0,
      fansNum: json["fansNum"] ?? 0,
      mutualFollow:
          UserAttentionStatus.valueForIndex(json["mutualFollow"] ?? 99),
      cavLevel: json["cavLevel"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "chatNo": chatNo,
        "avatar": avatar,
        "nickname": nickname,
        "signature": signature,
        "gender": gender,
        "zodiac": zodiac,
        "star": star,
        "birth": birth,
        "creationNum": creationNum,
        "fansNum": fansNum,
        "mutualFollow": mutualFollow.index,
        "cavLevel": cavLevel,
      };
}

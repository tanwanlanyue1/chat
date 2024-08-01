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
    required this.type,
    required this.state,
    required this.avatar,
    required this.serviceCharge,
    required this.nickname,
    required this.signature,
    // required this.images,
    required this.gender,
    required this.zodiac,
    required this.star,
    required this.birth,
    required this.age,
    required this.position,
    required this.email,
    required this.phone,
    required this.occupation,
    required this.style,
    required this.likeSex,
    required this.likeAgeMin,
    required this.likeAgeMax,
    required this.likeOccupation,
    required this.likeStyle,
    required this.creationNum,
    required this.fansNum,
    required this.mutualFollow,
    required this.cavLevel,
  });

  final int uid; // 用户id
  final int chatNo; // 用户编号
  final int type; // 用户类型 0普通用户 1佳丽 2经纪人
  final int state; // 在线状态 0不接约 1接约中 2约会进行中
  String? avatar; // 头像
  final int serviceCharge; // 服务费
  String? nickname; // 昵称
  String? signature; // 个性签名
  // String? images; // 个人图片
  int? gender; // 用户性别 1：男 2：女
  String? zodiac; // 生肖
  String? star; // 星座
  String? birth; // 生日yyyy-MM-dd
  final int age; // 年龄
  final String position; // 位置
  final String email; // 邮箱
  final String phone; // 联系电话
  final int occupation; // 职业 1在职人员 2学生
  final String style; // 风格
  final int likeSex; // 喜好性别 0：其它 1：男 2：女
  final int likeAgeMin; // 最小喜好年龄
  final int likeAgeMax; // 最大喜好年龄
  final int likeOccupation; // 喜好职业 1在职人员 2学生
  final String likeStyle; // 喜好风格

  /// 下面参数供关注或粉丝列表使用
  int creationNum; // 创作数
  int fansNum; // 粉丝数
  UserAttentionStatus mutualFollow; // 是否互关 0-未关注，1-关注，2-互关
  int cavLevel; // 修行等级

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"] ?? 0,
      chatNo: json["chatNo"] ?? 0,
      type: json["type"] ?? 0,
      state: json["state"] ?? 0,
      avatar: json["avatar"],
      serviceCharge: json["serviceCharge"] ?? 0,
      nickname: json["nickname"] ?? "",
      signature: json["signature"],
      // images: json["images"],
      gender: json["gender"],
      zodiac: json["zodiac"],
      star: json["star"],
      birth: json["birth"],
      age: json["age"] ?? 0,
      position: json["position"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      occupation: json["occupation"] ?? 0,
      style: json["style"] ?? "",
      likeSex: json["likeSex"] ?? 0,
      likeAgeMin: json["likeAgeMin"] ?? 0,
      likeAgeMax: json["likeAgeMax"] ?? 0,
      likeOccupation: json["likeOccupation"] ?? 0,
      likeStyle: json["likeStyle"] ?? "",
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
        "type": type,
        "state": state,
        "avatar": avatar,
        "serviceCharge": serviceCharge,
        "nickname": nickname,
        "signature": signature,
        // "images": String.toJson(),
        "gender": gender,
        "zodiac": zodiac,
        "star": star,
        "birth": birth,
        "age": age,
        "position": position,
        "email": email,
        "phone": phone,
        "occupation": occupation,
        "style": style,
        "likeSex": likeSex,
        "likeAgeMin": likeAgeMin,
        "likeAgeMax": likeAgeMax,
        "likeOccupation": likeOccupation,
        "likeStyle": likeStyle,
        "creationNum": creationNum,
        "fansNum": fansNum,
        "mutualFollow": mutualFollow.index,
        "cavLevel": cavLevel,
      };
}

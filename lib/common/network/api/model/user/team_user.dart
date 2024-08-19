//用户团队
class TeamUser {
  TeamUser({
    this.uid,
    //年龄
    this.age,
    //契约单id
    this.contractId,
    //	契约单备注 == apply时，申请取消
    this.remark,
    //用户类型 0普通用户 1佳丽 2经纪人
    this.type,
    //头像
    this.avatar,
    //	昵称
    this.nickname,
    //	用户性别 0：保密 1：男 2：女
    this.gender,});

  TeamUser.fromJson(dynamic json) {
    uid = json['uid'];
    age = json['age'];
    contractId = json['contractId'];
    remark = json['remark'];
    type = json['type'];
    avatar = json['avatar'];
    nickname = json['nickname'];
    gender = json['gender'];
  }
  int? uid;
  int? age;
  int? contractId;
  String? remark;
  int? type;
  String? avatar;
  String? nickname;
  int? gender;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['age'] = age;
    map['contractId'] = contractId;
    map['remark'] = remark;
    map['type'] = type;
    map['avatar'] = avatar;
    map['nickname'] = nickname;
    map['gender'] = gender;
    return map;
  }

}
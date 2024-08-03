///用户进阶查询
class UserAdvanced {
  UserAdvanced({
    this.id,
    //	用户Id
    this.uid,
    //	修改类型(1:昵称 2:头像 3:个性签名 4:进阶佳丽 5：进阶经纪人 6：进阶普通用户)
    this.type,
    //修改内容
    this.content,
    //审核状态 0审核中 1已通过 2未通过
    this.status,
    //备注，审核不通过原因
    this.remark,
    //创建时间
    this.createTime,
    //	更新时间
    this.updateTime,});

  UserAdvanced.fromJson(dynamic json) {
    id = json['id'];
    uid = json['uid'];
    type = json['type'];
    content = json['content'];
    status = json['status'];
    remark = json['remark'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }
  int? id;
  int? uid;
  int? type;
  String? content;
  int? status;
  String? remark;
  String? createTime;
  String? updateTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uid'] = uid;
    map['type'] = type;
    map['content'] = content;
    map['status'] = status;
    map['remark'] = remark;
    map['createTime'] = createTime;
    map['updateTime'] = updateTime;
    return map;
  }

}
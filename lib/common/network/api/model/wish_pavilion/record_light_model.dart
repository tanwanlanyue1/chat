
///放灯记录
class RecordLightModel {
  RecordLightModel({
    //点灯记录ID
    this.recordId,
    //用户ID
    this.uid,
    //礼物ID
    this.giftId,
    //灯的时效和费用配置ID
    this.configId,
    //祝福人数
    this.bless,
    //	接福者姓名
    this.name,
    //愿望、思念或者祝福语
    this.desire,
    //是否公开 0：公开 1：不公开
    this.open,
    //灯的状态 （河灯 0:可收起 1:可重新放灯 2:已结束）（天灯 0:可完愿 1：已完愿）
    this.status,
    //	灯结束时间
    this.endTime,
    //灯创建日期
    this.createTime,
    //礼物名称
    this.giftName,
    //礼物图片地址
    this.image,
    //礼物类型：1上香2供品，3河灯，4天灯，5供灯
    this.type,
    //子类型：type=4时,1婚恋2生活3学业4财运5事业
    this.subType,
    //礼物动效地址
    this.svga,
    //	礼物描述
    this.remark,
    // 我是否祝福
    this.isLike,
  });

  RecordLightModel.fromJson(dynamic json) {
    recordId = json['recordId'];
    uid = json['uid'];
    giftId = json['giftId'];
    configId = json['configId'];
    bless = json['bless'];
    name = json['name'];
    desire = json['desire'];
    open = json['open'];
    status = json['status'];
    endTime = json['endTime'];
    createTime = json['createTime'];
    giftName = json['giftName'];
    image = json['image'];
    type = json['type'];
    subType = json['subType'];
    svga = json['svga'];
    remark = json['remark'];
    isLike = json['isLike'];
  }
  int? recordId;
  int? uid;
  int? giftId;
  int? configId;
  int? bless;
  String? name;
  String? desire;
  int? open;
  int? status;
  String? endTime;
  String? createTime;
  String? giftName;
  String? image;
  int? type;
  int? subType;
  String? svga;
  String? remark;
  bool? isLike;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['recordId'] = recordId;
    map['uid'] = uid;
    map['giftId'] = giftId;
    map['configId'] = configId;
    map['bless'] = bless;
    map['name'] = name;
    map['desire'] = desire;
    map['open'] = open;
    map['status'] = status;
    map['endTime'] = endTime;
    map['createTime'] = createTime;
    map['giftName'] = giftName;
    map['image'] = image;
    map['type'] = type;
    map['subType'] = subType;
    map['svga'] = svga;
    map['remark'] = remark;
    map['isLike'] = isLike;
    return map;
  }

}
import 'package:guanjia/common/network/api/model/gift/gift_model.dart';

///放灯记录详情
class RecordDetailsModel {
  RecordDetailsModel({
    //	点灯记录ID
    this.id,
    //用户ID
    this.uid,
    //礼物ID
    this.giftId,
    //灯的时效和费用配置ID
    this.configId,
    //	祝福人数
    this.bless,
    //	接福者姓名
    this.name,
    //愿望、思念或者祝福语
    this.desire,
    //是否公开 0：公开 1：不公开
    this.open,
    //灯的状态 （河灯 0:可收起 1:可重新放灯 2:已结束）（天灯 0:可完愿 1：已完愿）
    this.status,
    //灯结束时间
    this.endTime,
    //礼物-列表
    this.gift,
    //	放灯者姓名
    this.userName,
    //	是否点赞 0：未点赞 1：已点赞
    this.isBless,
    //	最近点赞头像
    this.blessList,
  });

  RecordDetailsModel.fromJson(dynamic json) {
    id = json['id'];
    uid = json['uid'];
    giftId = json['giftId'];
    configId = json['configId'];
    bless = json['bless'];
    name = json['name'];
    desire = json['desire'];
    open = json['open'];
    status = json['status'];
    endTime = json['endTime'];
    gift = json['gift'] != null ? GiftModel.fromJson(json['gift']) : null;
    userName = json['userName'];
    isBless = json['isBless'];
    blessList = json['blessList'];
  }
  int? id;
  int? uid;
  int? giftId;
  int? configId;
  int? bless;
  String? name;
  String? desire;
  int? open;
  int? status;
  String? endTime;
  GiftModel? gift;
  String? userName;
  int? isBless;
  List? blessList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uid'] = uid;
    map['giftId'] = giftId;
    map['configId'] = configId;
    map['bless'] = bless;
    map['name'] = name;
    map['desire'] = desire;
    map['open'] = open;
    map['status'] = status;
    map['endTime'] = endTime;
    if (gift != null) {
      map['gift'] = gift?.toJson();
    }
    map['userName'] = userName;
    map['isBless'] = isBless;
    map['blessList'] = blessList;
    return map;
  }

}

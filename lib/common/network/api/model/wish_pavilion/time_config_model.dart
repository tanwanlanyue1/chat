
///礼物时效配置
class TimeConfigModel {
  TimeConfigModel({
    //时效ID
    this.id,
    //灯ID
    this.lanternId,
    //	时效（秒）
    this.periodTime,
    //费用
    this.goldNum,
    //默认时效选项 0：非默认 1：默认
    this.acquiesce,
    //+功德
    this.meritsVirtues,
    //+修行
    this.training,
    //总免费次数
    this.freeCount,
    //剩余免费次数
    this.surplusCount,
  });

  TimeConfigModel.fromJson(dynamic json) {
    id = json['id'];
    lanternId = json['lanternId'];
    periodTime = json['periodTime'];
    goldNum = json['goldNum'];
    acquiesce = json['acquiesce'];
    meritsVirtues = json['meritsVirtues'];
    training = json['training'];
    freeCount = json['freeCount'];
    surplusCount = json['surplusCount'];
  }
  int? id;
  int? lanternId;
  int? periodTime;
  int? goldNum;
  int? acquiesce;
  int? meritsVirtues;
  int? training;
  int? freeCount;
  int? surplusCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['lanternId'] = lanternId;
    map['periodTime'] = periodTime;
    map['goldNum'] = goldNum;
    map['acquiesce'] = acquiesce;
    map['meritsVirtues'] = meritsVirtues;
    map['training'] = training;
    map['freeCount'] = freeCount;
    map['surplusCount'] = surplusCount;
    return map;
  }

}
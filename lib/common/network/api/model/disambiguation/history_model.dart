//解疑玩法-历史记录
class HistoryModel {
  HistoryModel({
    //历史记录
    this.id,
    //type	玩法类型（1占卜 2塔罗牌 3取名 4星座-运势 5星座-星盘 6星座-配对 7运势 8解梦）
    this.type,
    //传入信息
    this.parameter,
    //	查询结果
    this.result,
    //	时间
    this.createTime,});

  HistoryModel.fromJson(dynamic json) {
    id = json['id'];
    type = json['type'];
    parameter = json['parameter'];
    result = json['result'];
    createTime = json['createTime'];
  }
  int? id;
  int? type;
  String? parameter;
  String? result;
  String? createTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['parameter'] = parameter;
    map['result'] = result;
    map['createTime'] = createTime;
    return map;
  }

}
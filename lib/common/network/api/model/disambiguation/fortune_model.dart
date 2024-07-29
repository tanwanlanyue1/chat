//运势model
class FortuneModel {
  FortuneModel({
    //生辰八字
    this.bazi,
    //返回结果
    this.result,});

  FortuneModel.fromJson(dynamic json) {
    bazi = json['bazi'];
    result = json['result'];
  }
  String? bazi;
  String? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bazi'] = bazi;
    map['result'] = result;
    return map;
  }

}
//解疑玩法-境修币
class DisabuseGoldModel {
  DisabuseGoldModel({
    //	玩法名称
    this.name,
    //玩法类型
    this.type,
    //花费境修币
    this.cost,
    //免费周期（秒）
    this.free,
    //+功德值
    this.mav,
    //+修行值
    this.cav,});

  DisabuseGoldModel.fromJson(dynamic json) {
    name = json['name'];
    type = json['type'];
    cost = json['cost'];
    free = json['free'];
    mav = json['mav'];
    cav = json['cav'];
  }
  String? name;
  int? type;
  int? cost;
  int? free;
  int? mav;
  int? cav;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['type'] = type;
    map['cost'] = cost;
    map['free'] = free;
    map['mav'] = mav;
    map['cav'] = cav;
    return map;
  }

}
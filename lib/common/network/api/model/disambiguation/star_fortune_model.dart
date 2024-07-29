
//星座运势
class StarFortuneModel {
  StarFortuneModel({
    //综合运势
    this.overview,
    //	爱情运势
    this.love,
    //事业运势
    this.career,
    //	财运运势
    this.money,
    //	健康运势
    this.health,
    //	幸运颜色
    this.luckyColor,
    //	幸运数字
    this.luckyNumber,
    //	速配星座
    this.speedMatchConstellation,
    //	提防星座
    this.bewareConstellation,
    //	综合百分比
    this.overviewPercent,
    //	爱情百分比
    this.lovePercent,
    //	事业百分比
    this.careerPercent,
    //心情百分比
    this.moodPercent,
    //交际百分比
    this.socialPercent,
    //财富百分比
    this.moneyPercent,
    //	健康百分比
    this.healthPercent,
  });

  StarFortuneModel.fromJson(dynamic json) {
    overview = json['overview'];
    love = json['love'];
    career = json['career'];
    money = json['money'];
    health = json['health'];
    luckyColor = json['luckyColor'];
    luckyNumber = json['luckyNumber'];
    speedMatchConstellation = json['speedMatchConstellation'];
    bewareConstellation = json['bewareConstellation'];
    overviewPercent = json['overviewPercent'];
    lovePercent = json['lovePercent'];
    careerPercent = json['careerPercent'];
    moodPercent = json['moodPercent'];
    socialPercent = json['socialPercent'];
    moneyPercent = json['moneyPercent'];
    healthPercent = json['healthPercent'];
  }
  String? overview;
  String? love;
  String? career;
  String? money;
  String? health;
  String? luckyColor;
  String? luckyNumber;
  String? speedMatchConstellation;
  String? bewareConstellation;
  String? overviewPercent;
  String? lovePercent;
  String? careerPercent;
  String? moodPercent;
  String? socialPercent;
  String? moneyPercent;
  String? healthPercent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['overview'] = overview;
    map['love'] = love;
    map['career'] = career;
    map['money'] = money;
    map['health'] = health;
    map['luckyColor'] = luckyColor;
    map['luckyNumber'] = luckyNumber;
    map['speedMatchConstellation'] = speedMatchConstellation;
    map['bewareConstellation'] = bewareConstellation;
    map['overviewPercent'] = overviewPercent;
    map['lovePercent'] = lovePercent;
    map['careerPercent'] = careerPercent;
    map['moodPercent'] = moodPercent;
    map['socialPercent'] = socialPercent;
    map['moneyPercent'] = moneyPercent;
    map['healthPercent'] = healthPercent;
    return map;
  }

}
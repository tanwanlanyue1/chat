
///星座-星盘
class AstrolabeModel {
  AstrolabeModel({
    //行星名称（包括中天，但中天没有宫位信息）
    this.planetName,
    //行星位置
    this.planetPosition,
    //	星座
    this.zodiacSign,
    //	个性特征
    this.personalityTraits,
    //	宫位号数
    this.houseNumber,
    //	宫位名称
    this.houseName,
    //	宫位特征
    this.houseTraits,});

  AstrolabeModel.fromJson(dynamic json) {
    planetName = json['planetName'];
    planetPosition = json['planetPosition'];
    zodiacSign = json['zodiacSign'];
    personalityTraits = json['personalityTraits'];
    houseNumber = json['houseNumber'];
    houseName = json['houseName'];
    houseTraits = json['houseTraits'];
  }
  String? planetName;
  String? planetPosition;
  String? zodiacSign;
  String? personalityTraits;
  int? houseNumber;
  String? houseName;
  String? houseTraits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['planetName'] = planetName;
    map['planetPosition'] = planetPosition;
    map['zodiacSign'] = zodiacSign;
    map['personalityTraits'] = personalityTraits;
    map['houseNumber'] = houseNumber;
    map['houseName'] = houseName;
    map['houseTraits'] = houseTraits;
    return map;
  }

}
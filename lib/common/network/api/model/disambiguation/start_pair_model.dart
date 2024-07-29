//星座配对model
class StartPairModel {
  StartPairModel({
      this.zodiacSign, 
      this.mutualAffection, 
      this.lastingLove, 
      this.friendship, 
      this.love, 
      this.marriage, 
      this.familyAffinity, 
      this.pairScore, 
      this.pairDescription, 
      this.relationshipAnalysis, 
      this.loveAnalysis, 
      this.interactionAnalysis, 
      this.communicationAnalysis,});

  StartPairModel.fromJson(dynamic json) {
    zodiacSign = json['zodiacSign'];
    mutualAffection = json['mutualAffection'];
    lastingLove = json['lastingLove'];
    friendship = json['friendship'];
    love = json['love'];
    marriage = json['marriage'];
    familyAffinity = json['familyAffinity'];
    pairScore = json['pairScore'];
    pairDescription = json['pairDescription'];
    relationshipAnalysis = json['relationshipAnalysis'];
    loveAnalysis = json['loveAnalysis'];
    interactionAnalysis = json['interactionAnalysis'];
    communicationAnalysis = json['communicationAnalysis'];
  }
  //	星座合称
  String? zodiacSign;
  //两情相悦值
  int? mutualAffection;
  //天长地久值
  int? lastingLove;
  //友情值
  int? friendship;
  //爱情值
  int? love;
  //婚姻值
  int? marriage;
  //亲情值
  int? familyAffinity;
  //匹配度
  int? pairScore;
  //匹配说明
  String? pairDescription;
  //关系分析
  String? relationshipAnalysis;
  //恋爱分析
  String? loveAnalysis;
  //相处分析
  String? interactionAnalysis;
  //沟通分析
  String? communicationAnalysis;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zodiacSign'] = zodiacSign;
    map['mutualAffection'] = mutualAffection;
    map['lastingLove'] = lastingLove;
    map['friendship'] = friendship;
    map['love'] = love;
    map['marriage'] = marriage;
    map['familyAffinity'] = familyAffinity;
    map['pairScore'] = pairScore;
    map['pairDescription'] = pairDescription;
    map['relationshipAnalysis'] = relationshipAnalysis;
    map['loveAnalysis'] = loveAnalysis;
    map['interactionAnalysis'] = interactionAnalysis;
    map['communicationAnalysis'] = communicationAnalysis;
    return map;
  }

}

///今日修行统计
class TodayCultivationStatsModel {
  TodayCultivationStatsModel({
    required this.tributeCount,
    required this.prayCount,
    required this.recitationCount,
    required this.scripturesCount,
    required this.beadsCount,
    required this.userName,
    required this.avatar,
    required this.currentMavDay,
    required this.mavDay,
    required this.sumBeads,
    required this.sumRecitation,
  });

  ///	今日供礼次数
  final int tributeCount;

  ///	今日上香次数
  final int prayCount;

  ///今日木鱼次数
  final int recitationCount;

  ///今日木鱼诵经次数
  final int scripturesCount;

  ///	今日念珠次数
  final int beadsCount;

  ///	用户名
  final String userName;

  ///	用户头像
  final String avatar;

  ///	用户连续修行天数
  final int currentMavDay;

  ///	用户累计修行天数
  final int mavDay;

  ///	用户累计念珠次数
  final int sumBeads;

  ///用户累计木鱼诵经次数
  final int sumRecitation;

  factory TodayCultivationStatsModel.fromJson(Map<String, dynamic> json){
    return TodayCultivationStatsModel(
      tributeCount: json["tributeCount"] ?? 0,
      prayCount: json["prayCount"] ?? 0,
      recitationCount: json["recitationCount"] ?? 0,
      scripturesCount: json["scripturesCount"] ?? 0,
      beadsCount: json["beadsCount"] ?? 0,
      userName: json["userName"] ?? "",
      avatar: json["avatar"] ?? "",
      currentMavDay: json["currentMavDay"] ?? 0,
      mavDay: json["mavDay"] ?? 0,
      sumBeads: json["sumBeads"] ?? 0,
      sumRecitation: json["sumRecitation"] ?? 0,
    );
  }

}

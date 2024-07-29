
///功德修行排行榜
class CultivationRankingModel {
  CultivationRankingModel({
    required this.uid,
    required this.ranking,
    required this.avatar,
    required this.name,
    required this.number,
    required this.oneself,
  });

  ///用户ID
  final int uid;

  ///排名
  final int ranking;

  ///	头像
  final String avatar;

  ///昵称
  final String name;

  ///次数
  final int number;

  ///是否是用户自己的排行 0：不是 1：是
  final int oneself;

  factory CultivationRankingModel.fromJson(Map<String, dynamic> json){
    return CultivationRankingModel(
      uid: json["uid"] ?? 0,
      ranking: json["ranking"] ?? 0,
      avatar: json["avatar"] ?? "",
      name: json["name"] ?? "",
      number: json["number"] ?? 0,
      oneself: json["oneself"] ?? 0,
    );
  }

}

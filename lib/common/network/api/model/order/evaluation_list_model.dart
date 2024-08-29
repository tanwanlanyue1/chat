//订单评价
class EvaluationListModel {
  EvaluationListModel({
    required this.list,
    required this.totalAppointment,
    required this.totalScore,
    required this.myTag,
  });

  final List<EvaluationItemModel> list; // 用户评价列表
  final int totalAppointment; // 累计约会次数
  final int totalScore; // 综合评分
  final String myTag; // 我的标签 逗号隔开

  factory EvaluationListModel.fromJson(Map<String, dynamic> json) {
    return EvaluationListModel(
      list: json["list"] == null
          ? []
          : List<EvaluationItemModel>.from(
              json["list"]!.map((x) => EvaluationItemModel.fromJson(x))),
      totalAppointment: json["totalAppointment"] ?? 0,
      totalScore: json["totalScore"] ?? 0,
      myTag: json["myTag"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "list": list.map((x) => x.toJson()).toList(),
        "totalAppointment": totalAppointment,
        "totalScore": totalScore,
        "myTag": myTag,
      };
}

class EvaluationItemModel {
  EvaluationItemModel({
    required this.content,
    required this.createTime,
    required this.star,
    required this.tag,
    required this.fromImg,
    required this.fromName,
    required this.toImg,
    required this.toName,
  });

  final String content; // 评价内容
  final int createTime; // 评价时间
  final int star; // 评价星级
  final String tag; // 评价标签
  final String fromImg; // 评价人头像
  final String fromName; // 评价人昵称
  final String toImg; // 被评价人头像
  final String toName; // 被评价人昵称

  factory EvaluationItemModel.fromJson(Map<String, dynamic> json) {
    return EvaluationItemModel(
      content: json["content"] ?? "",
      createTime: json["createTime"] ?? 0,
      star: json["star"] ?? 0,
      tag: json["tag"] ?? "",
      fromImg: json["fromImg"] ?? "",
      fromName: json["fromName"] ?? "",
      toImg: json["toImg"] ?? "",
      toName: json["toName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "content": content,
        "createTime": createTime,
        "star": star,
        "tag": tag,
        "fromImg": fromImg,
        "fromName": fromName,
        "toImg": toImg,
        "toName": toName,
      };
}

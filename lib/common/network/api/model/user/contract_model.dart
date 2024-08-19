
///契约
class ContractModel {
  ContractModel({
    required this.id,
    required this.partyAId,
    required this.partyAName,
    required this.partyAHead,
    required this.partyBId,
    required this.partyBName,
    required this.partyBHead,
    required this.content,
    required this.brokerageService,
    required this.brokerageChatting,
    required this.state,
    required this.remark,
    required this.signingTime,
    required this.rescissionTime,
    required this.createTime,
  });

  ///	id
  final int id;
  ///	甲方id
  final int partyAId;
  ///	甲方姓名
  final String partyAName;
  ///	甲方头像
  final String partyAHead;
  ///	乙方id
  final int partyBId;
  ///		乙方姓名
  final String partyBName;
  ///	乙方头像
  final String partyBHead;
  ///	契约单内容
  final String content;
  ///服务费甲方分成比例%
  final num brokerageService;
  ///陪聊甲方分成比例%
  final num brokerageChatting;
  ///签约状态 0签约中 1生效中 2已结束
  final int state;
  ///	备注
  final String remark;
  ///	签约时间
  final String signingTime;
  ///	解除时间
  final String rescissionTime;
  ///	创建时间
  final String createTime;

  factory ContractModel.fromJson(Map<String, dynamic> json){
    return ContractModel(
      id: json["id"] ?? 0,
      partyAId: json["partyAId"] ?? 0,
      partyAName: json["partyAName"] ?? "",
      partyAHead: json["partyAHead"] ?? "",
      partyBId: json["partyBId"] ?? 0,
      partyBName: json["partyBName"] ?? "",
      partyBHead: json["partyBHead"] ?? "",
      content: json["content"] ?? "",
      brokerageService: json["brokerageService"] ?? 0,
      brokerageChatting: json["brokerageChatting"] ?? 0,
      state: json["state"] ?? 0,
      remark: json["remark"] ?? "",
      signingTime: json["signingTime"] ?? "",
      rescissionTime: json["rescissionTime"] ?? "",
      createTime: json["createTime"] ?? "",
    );
  }

  ContractModel copyWith({
    int? id,
    int? partyAId,
    String? partyAName,
    String? partyAHead,
    int? partyBId,
    String? partyBName,
    String? partyBHead,
    String? content,
    num? brokerageService,
    num? brokerageChatting,
    int? state,
    String? remark,
    String? signingTime,
    String? rescissionTime,
    String? createTime,
  }) {
    return ContractModel(
      id: id ?? this.id,
      partyAId: partyAId ?? this.partyAId,
      partyAName: partyAName ?? this.partyAName,
      partyAHead: partyAHead ?? this.partyAHead,
      partyBId: partyBId ?? this.partyBId,
      partyBName: partyBName ?? this.partyBName,
      partyBHead: partyBHead ?? this.partyBHead,
      content: content ?? this.content,
      brokerageService: brokerageService ?? this.brokerageService,
      brokerageChatting: brokerageChatting ?? this.brokerageChatting,
      state: state ?? this.state,
      remark: remark ?? this.remark,
      signingTime: signingTime ?? this.signingTime,
      rescissionTime: rescissionTime ?? this.rescissionTime,
      createTime: createTime ?? this.createTime,
    );
  }


}

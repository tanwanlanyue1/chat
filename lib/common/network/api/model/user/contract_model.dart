
///契约
class ContractModel {
  ContractModel({
    required this.id,
    required this.partyA,
    required this.partyAName,
    required this.partyB,
    required this.partyBName,
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
  final int partyA;
  ///	甲方姓名
  final String partyAName;
  ///	乙方id
  final int partyB;
  ///		乙方姓名
  final String partyBName;
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

  ///完整合约内容(包含分成比例)
  String get fullContent{
    return content.replaceFirst('{brokerageService}', '$brokerageService%')
    .replaceFirst('{brokerageChatting}', '$brokerageChatting%');
  }

  factory ContractModel.fromJson(Map<String, dynamic> json){
    return ContractModel(
      id: json["id"] ?? 0,
      partyA: json["partyA"] ?? 0,
      partyAName: json["partyAName"] ?? "",
      partyB: json["partyB"] ?? 0,
      partyBName: json["partyBName"] ?? "",
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
    int? partyA,
    String? partyAName,
    int? partyB,
    String? partyBName,
    String? content,
    int? brokerageService,
    int? brokerageChatting,
    int? state,
    String? remark,
    String? signingTime,
    String? rescissionTime,
    String? createTime,
  }) {
    return ContractModel(
      id: id ?? this.id,
      partyA: partyA ?? this.partyA,
      partyAName: partyAName ?? this.partyAName,
      partyB: partyB ?? this.partyB,
      partyBName: partyBName ?? this.partyBName,
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

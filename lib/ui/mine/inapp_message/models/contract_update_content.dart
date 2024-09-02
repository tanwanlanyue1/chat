

///合约变更 应用内消息内容
class ContractUpdateContent {

  ///合约ID
  final int contractId;

  ContractUpdateContent({
    required this.contractId,
  });

  factory ContractUpdateContent.fromJson(Map<String, dynamic> json) {
    return ContractUpdateContent(
      contractId: json['contractId'] ?? 0,
    );
  }
}

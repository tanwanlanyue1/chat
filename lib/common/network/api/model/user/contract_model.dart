
///契约
class ContractModel{
  ContractModel({
    required this.id,
    required this.broker,
    required this.date,
    required this.status,
  });

  ///唯一id
  final String id;

  ///经纪人
  final String broker;

  ///生效时间
  final String date;

  ///状态 0未签约, 1签约中, 2已签约, 3已解除
  final int status;

}
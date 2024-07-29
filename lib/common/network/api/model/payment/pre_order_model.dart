///预下单信息
class PreOrderModel {
  PreOrderModel({
    required this.orderNo,
  });

  ///订单号
  final String orderNo;


  factory PreOrderModel.fromJson(Map<String, dynamic> json){
    return PreOrderModel(
      orderNo: json["orderNo"] ?? "",
    );
  }

}

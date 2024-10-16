
class WithdrawOrderModel {
  WithdrawOrderModel({
    required this.id,
    required this.uid,
    required this.amount,
    required this.address,
    required this.state,
    required this.createTime,
    required this.updateTime,
  });

  final int id;

  ///	用户id
  final int uid;

  ///	提现金额
  final num amount;

  ///	钱包地址
  final String address;

  ///	提现状态 0已申请 1已完成 2失败
  final int state;

  ///	创建时间
  final int createTime;

  ///	更新时间
  final int updateTime;

  factory WithdrawOrderModel.fromJson(Map<String, dynamic> json){
    return WithdrawOrderModel(
      id: json["id"] ?? 0,
      uid: json["uid"] ?? 0,
      amount: json["amount"] ?? 0,
      address: json["address"] ?? "",
      state: json["state"] ?? 0,
      createTime: json["createTime"] ?? 0,
      updateTime: json["updateTime"] ?? 0,
    );
  }

}

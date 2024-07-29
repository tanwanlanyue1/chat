
///念珠-付费商品
class RosaryBeadsProductModel {
  RosaryBeadsProductModel({
    required this.id,
    required this.type,
    required this.image,
    required this.purchase,
    required this.price,
    required this.isBuy,
  });

  ///ID
  final int id;

  ///类型 0:佛珠1:背景
  final int type;

  ///图片地址
  final String image;

  ///是否需要购买 0:否1:是
  final int purchase;

  ///	价格
  final int price;

  ///	当前用户是否已购买 0:否1:是
  final int isBuy;

  factory RosaryBeadsProductModel.fromJson(Map<String, dynamic> json){
    return RosaryBeadsProductModel(
      id: json["id"] ?? 0,
      type: json["type"] ?? 0,
      image: json["image"] ?? "",
      purchase: json["purchase"] ?? 0,
      price: json["price"] ?? 0,
      isBuy: json["isBuy"] ?? 0,
    );
  }

  RosaryBeadsProductModel copyWith({
    int? id,
    int? type,
    String? image,
    int? purchase,
    int? price,
    int? isBuy,
  }) {
    return RosaryBeadsProductModel(
      id: id ?? this.id,
      type: type ?? this.type,
      image: image ?? this.image,
      purchase: purchase ?? this.purchase,
      price: price ?? this.price,
      isBuy: isBuy ?? this.isBuy,
    );
  }

}

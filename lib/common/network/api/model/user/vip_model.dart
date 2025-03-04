import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';

class VipModel {
  VipModel({
    required this.userInfo,
    required this.benefits,
    required this.packages,
    required this.swiperList,
  });

  final UserModel? userInfo;
  final List<Benefit> benefits;
  final List<VipPackageModel> packages;
  final List<VipSwiperItem> swiperList;

  factory VipModel.fromJson(Map<String, dynamic> json) {
    return VipModel(
      userInfo: json["userInfo"] == null
          ? null
          : UserModel.fromJson(json["userInfo"]),
      benefits: json["benefits"] == null
          ? []
          : List<Benefit>.from(
              json["benefits"]!.map((x) => Benefit.fromJson(x))),
      packages: json["packages"] == null
          ? []
          : List<VipPackageModel>.from(
              json["packages"]!.map((x) => VipPackageModel.fromJson(x))),
      swiperList: json["swiperList"] == null
          ? []
          : List<VipSwiperItem>.from(json["swiperList"]!.map((x) => VipSwiperItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "userInfo": userInfo?.toJson(),
        "benefits": benefits.map((x) => x.toJson()).toList(),
        "packages": packages.map((x) => x.toJson()).toList(),
        "swiperList": swiperList.map((x) => x).toList(),
      };
}

class VipSwiperItem{
  final String avatar;
  final String text;

  VipSwiperItem(this.avatar, this.text);

  factory VipSwiperItem.fromJson(Map<String, dynamic> json){
    return VipSwiperItem(
        json['avatar'] ?? '',
        json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "avatar": avatar,
    "text": text,
  };
}

class Benefit {
  Benefit({
    required this.type,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.count,
    required this.bigIcon,
    required this.color,
    required this.bigTitle,
    required this.bigSubTitle,
  });

  final int type; // 权益类型
  final String title; // 权益标题
  final String subTitle; // 权益副标题
  final String icon; // 权益图标
  final int count; // 权益次数 0=不限
  final String bigIcon; // 背景图标
  final String color; // 背景颜色
  final String bigTitle; // 权益背景标题
  final String bigSubTitle; // 权益背景副标题

  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(
      type: json["type"] ?? 0,
      title: json["title"] ?? "",
      subTitle: json["subTitle"] ?? "",
      icon: json["icon"] ?? "",
      count: json["count"] ?? 0,
      bigIcon: json["bigIcon"] ?? "",
      color: json["color"] ?? "",
      bigTitle: json["bigTitle"] ?? "",
      bigSubTitle: json["bigSubTitle"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "subTitle": subTitle,
        "icon": icon,
        "count": count,
        "bigIcon": bigIcon,
        "color": color,
        "bigTitle": bigTitle,
        "bigSubTitle": bigSubTitle,
      };
}

class VipPackageModel {
  VipPackageModel({
    required this.id,
    required this.price,
    required this.discountPrice,
    required this.duration,
    required this.discount,
    required this.title,
    required this.nameplate,
  });

  final int id; // id
  final num price; // 价格
  final num discountPrice; // 优惠价格
  final int duration; // 开通时长(月)
  final int discount; // 优惠 0无优惠 1限时特惠
  final String title; // 标题
  final String nameplate; // vip图标

  String get durationText => S.current.entriesMonth(duration);

  factory VipPackageModel.fromJson(Map<String, dynamic> json) {
    return VipPackageModel(
      id: json["id"] ?? 0,
      price: json["price"] ?? 0,
      discountPrice: json["discountPrice"] ?? 0,
      duration: json["duration"] ?? 0,
      discount: json["discount"] ?? 0,
      title: json["title"] ?? "",
      nameplate: json["nameplate"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "discountPrice": discountPrice,
        "duration": duration,
        "discount": discount,
        "title": title,
        "nameplate": nameplate,
      };
}

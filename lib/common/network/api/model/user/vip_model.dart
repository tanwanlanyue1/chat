class VipModel {
  VipModel({
    required this.userInfo,
    required this.benefits,
    required this.packages,
  });

  final UserInfo? userInfo;
  final List<Benefit> benefits;
  final List<Package> packages;

  factory VipModel.fromJson(Map<String, dynamic> json) {
    return VipModel(
      userInfo:
          json["userInfo"] == null ? null : UserInfo.fromJson(json["userInfo"]),
      benefits: json["benefits"] == null
          ? []
          : List<Benefit>.from(
              json["benefits"]!.map((x) => Benefit.fromJson(x))),
      packages: json["packages"] == null
          ? []
          : List<Package>.from(
              json["packages"]!.map((x) => Package.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "userInfo": userInfo?.toJson(),
        "benefits": benefits.map((x) => x?.toJson()).toList(),
        "packages": packages.map((x) => x?.toJson()).toList(),
      };
}

class Benefit {
  Benefit({
    required this.type,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.count,
  });

  final int type;
  final String title;
  final String subTitle;
  final String icon;
  final int count;

  factory Benefit.fromJson(Map<String, dynamic> json) {
    return Benefit(
      type: json["type"] ?? 0,
      title: json["title"] ?? "",
      subTitle: json["subTitle"] ?? "",
      icon: json["icon"] ?? "",
      count: json["count"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "subTitle": subTitle,
        "icon": icon,
        "count": count,
      };
}

class Package {
  Package({
    required this.id,
    required this.price,
    required this.discountPrice,
    required this.duration,
    required this.discount,
  });

  final int id;
  final int price;
  final int discountPrice;
  final int duration;
  final int discount;

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json["id"] ?? 0,
      price: json["price"] ?? 0,
      discountPrice: json["discountPrice"] ?? 0,
      duration: json["duration"] ?? 0,
      discount: json["discount"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "discountPrice": discountPrice,
        "duration": duration,
        "discount": discount,
      };
}

class UserInfo {
  UserInfo({
    required this.uid,
    required this.nickName,
    required this.avatar,
    required this.type,
    required this.isOpen,
    required this.expirationTime,
  });

  final int uid;
  final String nickName;
  final String avatar;
  final int type;
  final bool isOpen;
  final int expirationTime;

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      uid: json["uid"] ?? 0,
      nickName: json["nickName"] ?? "",
      avatar: json["avatar"] ?? "",
      type: json["type"] ?? 0,
      isOpen: json["isOpen"] ?? false,
      expirationTime: json["expirationTime"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "nickName": nickName,
        "avatar": avatar,
        "type": type,
        "isOpen": isOpen,
        "expirationTime": expirationTime,
      };
}

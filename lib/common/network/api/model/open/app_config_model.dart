import 'package:guanjia/common/network/api/model/user/vip_model.dart';

class AppConfigModel {
  AppConfigModel({
    this.serverTime,
    this.jumpLink,
    //	注销账号H5链接
    this.cancelAccountLink,
    this.deposit,
    this.goldPrice,
    this.minPayGold,
    this.tab,
    this.home,
    this.resources,
    this.scriptures,
    this.desc,
    this.matchingCountDown,
    this.styleList,
    this.defaultStyle,
  });

  int? serverTime;
  String? jumpLink;
  String? cancelAccountLink;

  ///	保证金
  num? deposit;

  ///一个境修币兑换多少人民币（单价）
  num? goldPrice;

  ///最低充值境修币数量
  int? minPayGold;

  ///充值提示语
  String? payGoldRule;
  List<LogTypeIcon>? logTypeIcon;
  List<TabItem>? tab;
  List<Home>? home;
  List<dynamic>? resources;
  String? desc;

  ///佛经大全的头部文本
  List<String>? scriptures;

  ///约会服务费收益比例模板 {brokerageService} TODO 预留字段，服务端还没有
  String? brokerageServiceTemplate;

  ///音视频陪聊收益比例模板 {brokerageChatting} TODO 预留字段，服务端还没有
  String? brokerageChattingTemplate;

  ///免费通话时间 秒
  num? chatFreeSecond;

  ///视频通话单价(每分钟)
  num? videoChatPrice;

  ///语音通话单价(每分钟)
  num? voiceChatPrice;

  ///通话最低余额
  num? chatMinBalance;

  ///红包最大金额 TODO 预留字段，服务端还没有
  num? redPacketMaxAmount;

  ///红包描述文字数量 TODO 预留字段，服务端还没有
  int? redPacketDescLimit;

  ///最大转账金额 TODO 预留字段，服务端还没有
  num? transferMaxAmount;

  ///金额小数位精度 TODO 预留字段，服务端还没有
  int? decimalDigits;

  ///是否启用人机校验
  bool? googleVerification;

  ///速配倒计时
  int? matchingCountDown;

  ///系统消息
  bool? systemMessage;

  ///谁看过我
  bool? lookMessage;

  ///钱包提现提示
  String? withdrawTips;

  ///钱包充值支付提示
  String? payTips;

  ///提现手续费
  num? withdrawFee;

  ///最低提现金额
  num? withdrawMinAmount;

  /// 拼接 标签
  List<LabelModel>? labels;

  List<LabelModel>? styleList;

  LabelModel? defaultStyle;

  ///vip的信息
  VipModel? vipInfo;

  ///亚马逊图片裁剪URL
  String? amazonawsCloudFront;

  List<LabelModel> get commonStyleList {
    if (styleList == null) return [];
    return styleList!.where((element) => element.type == 0).toList();
  }

  List<LabelModel> get maleStyleList {
    if (styleList == null) return [];
    return styleList!.where((element) => element.type == 1).toList();
  }

  List<LabelModel> get femaleStyleList {
    if (styleList == null) return [];
    return styleList!.where((element) => element.type == 2).toList();
  }

  List<LabelModel> get friendStyleList {
    if (styleList == null) return [];
    return styleList!.where((element) => element.type == 3).toList();
  }

  AppConfigModel.fromJson(dynamic json) {
    serverTime = json['serverTime'];
    jumpLink = json['jumpLink'];
    cancelAccountLink = json['cancelAccountLink'];
    deposit = json['deposit'];
    goldPrice = json['goldPrice'];
    minPayGold = json['minPayGold'];
    payGoldRule = json['payGoldRule'];
    if (json['tab'] != null) {
      tab = [];
      json['tab'].forEach((v) {
        tab?.add(TabItem.fromJson(v));
      });
    }
    if (json['logTypeIcon'] is List) {
      logTypeIcon = [];
      json['logTypeIcon'].forEach((v) {
        logTypeIcon?.add(LogTypeIcon.fromJson(v));
      });
    }
    if (json['home'] != null) {
      home = [];
      json['home'].forEach((v) {
        home?.add(Home.fromJson(v));
      });
    }
    if (json['resources'] != null) {
      resources = [];
      json['resources'].forEach((v) {
        resources?.add(v);
      });
    }
    if (json['scriptures'] is List) {
      scriptures = [];
      json['scriptures'].forEach((v) {
        scriptures?.add(v.toString());
      });
    }
    if (json['styleList'] is List) {
      styleList = [];
      json['styleList'].forEach((v) {
        if (v is Map<String, dynamic>) {
          styleList?.add(LabelModel.fromJson(v));
        }
      });
    }
    if (json['defaultStyle'] is Map) {
      defaultStyle = LabelModel.fromJson(json['defaultStyle']);
    }
    if (json['vipInfo'] is Map) {
      vipInfo = VipModel.fromJson(json['vipInfo']);
    }
    desc = json['desc'];
    brokerageServiceTemplate = json['brokerageServiceTemplate'];
    brokerageChattingTemplate = json['brokerageChattingTemplate'];
    chatFreeSecond = json['chatFreeSecond'];
    videoChatPrice = json['videoChatPrice'];
    voiceChatPrice = json['voiceChatPrice'];
    chatMinBalance = json['chatMinBalance'];
    matchingCountDown = json['matchingCountDown'];
    redPacketMaxAmount = json['redPacketMaxAmount'];
    redPacketDescLimit = json['redPacketDescLimit'];
    transferMaxAmount = json['transferMaxAmount'];
    decimalDigits = json['decimalDigits'];
    googleVerification = json['googleVerification'];
    systemMessage = json['systemMessage'];
    lookMessage = json['lookMessage'];
    withdrawTips = json['withdrawTips'];
    payTips = json['payTips'];
    withdrawFee = json['withdrawFee'];
    withdrawMinAmount = json['withdrawMinAmount'];
    amazonawsCloudFront = json['amazonawsCloudFront'];
  }
}

class Home {
  Home({
    this.name,
    this.icon,
    this.selectIcon,
    this.background,
    this.h1,
    this.h2,
    //唯一ID，不可更改
    this.id,
  });

  Home.fromJson(dynamic json) {
    name = json['name'];
    icon = json['icon'];
    selectIcon = json['selectIcon'];
    background = json['background'];
    h1 = json['h1'];
    h2 = json['h2'];
    id = json['id'];
  }

  String? name;
  String? icon;
  String? selectIcon;
  String? background;
  String? h1;
  String? h2;
  int? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['icon'] = icon;
    map['selectIcon'] = selectIcon;
    map['background'] = background;
    map['h1'] = h1;
    map['h2'] = h2;
    map['id'] = id;
    return map;
  }
}

class TabItem {
  TabItem({
    this.icon,
    this.selectIcon,
    this.text,
  });

  TabItem.fromJson(dynamic json) {
    icon = json['icon'];
    selectIcon = json['selectIcon'];
    text = json['text'];
  }

  String? icon;
  String? selectIcon;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['icon'] = icon;
    map['selectIcon'] = selectIcon;
    map['text'] = text;
    return map;
  }
}

class LogTypeIcon {
  LogTypeIcon({
    required this.logType,
    required this.icon,
    required this.name,
  });

  factory LogTypeIcon.fromJson(dynamic json) => LogTypeIcon(
        logType: json['logType'] ?? 0,
        icon: json['icon'] ?? '',
        name: json['name'] ?? '',
      );

  final int logType;
  final String icon;
  final String name;
}

class LabelModel {
  LabelModel({
    required this.id,
    required this.type,
    required this.tag,
    required this.icon,
  });

  final int id;
  final int type; // 类型 0通用 1男 2女
  final String tag; // 风格类型
  final String icon; // 风格图片

  factory LabelModel.fromJson(Map<String, dynamic> json) {
    return LabelModel(
      id: json["id"] ?? 0,
      type: json["type"] ?? 0,
      tag: json["tag"] ?? "",
      icon: json["icon"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "tag": tag,
        "icon": icon,
      };
}
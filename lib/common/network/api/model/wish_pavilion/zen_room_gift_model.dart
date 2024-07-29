
import 'dart:convert';

import 'package:guanjia/common/utils/app_logger.dart';

///禅房供品
class ZenRoomGiftModel {
  ZenRoomGiftModel({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.subType,
    required this.extraJson,
    required this.extraConfig,
    required this.defaultBack,
    required this.remark,
    required this.goldNum,
    required this.svga,
    required this.periodTime,
    required this.mavNum,
    required this.cavNum,
    required this.freeCount,
    required this.surplusCount,
    required this.afterFree,
  });

  /// ID
  final int id;

  ///	礼物名称
  final String name;

  ///礼物图片地址
  final String image;

  ///礼物图片地址（小图-香炉专用）
  String get thumbImg{
    return extraMap['thumbImg'] ?? '';
  }
  ///烟雾特效（香炉专用）
  String get smokeSvga{
    return extraMap['smokeSvga'] ?? '';
  }

  ///佛字特效（香炉专用）
  String get buddhaSvga{
    return extraMap['buddhaSvga'] ?? '';
  }

  ///礼物类型：1上香2供品，3河灯，4天灯，5供灯
  final int type;

  ///子类型：type=4时,1婚恋2生活3学业4财运5事业
  final int subType;

  ///扩展字段
  final String extraJson;

  Map<String, dynamic>? _extraJson;

  ///扩展字段解析为map
  Map<String, dynamic> get extraMap{
    try{
      return _extraJson ??= jsonDecode(extraJson);
    }catch(ex){
      // AppLogger.d(ex);
    }
   return {};
  }

  ///是否有多种时效配置 0：无 1：有
  final int extraConfig;

  ///	默认文案
  final String defaultBack;

  ///	备注
  final String remark;

  ///境修币价格 0表示免费
  final int goldNum;

  ///礼物动效地址
  final String svga;

  ///有效时间（秒）
  final int periodTime;

  ///	+功德值
  final int mavNum;

  ///+修行值
  final int cavNum;

  ///	总免费次数
  final int freeCount;

  ///剩余免费次数
  final int surplusCount;

  ///	免费次数用完之后的价格
  final int afterFree;

  factory ZenRoomGiftModel.fromJson(Map<String, dynamic> json){
    return ZenRoomGiftModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      type: json["type"] ?? 0,
      subType: json["subType"] ?? 0,
      extraJson: json["extraJson"] ?? "",
      extraConfig: json["extraConfig"] ?? 0,
      defaultBack: json["defaultBack"] ?? "",
      remark: json["remark"] ?? "",
      goldNum: json["goldNum"] ?? 0,
      svga: json["svga"] ?? "",
      periodTime: json["periodTime"] ?? 0,
      mavNum: json["mavNum"] ?? 0,
      cavNum: json["cavNum"] ?? 0,
      freeCount: json["freeCount"] ?? 0,
      surplusCount: json["surplusCount"] ?? 0,
      afterFree: json["afterFree"] ?? 0,
    );
  }

}

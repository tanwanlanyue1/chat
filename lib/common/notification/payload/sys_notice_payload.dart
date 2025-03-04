
import 'dart:convert';

import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/utils/app_logger.dart';

///系统通知Payload
class SysNoticePayload {

  /// 最新消息类型 0系统公告 1个人通知
  final int? type;

  /// 跳转类型（0无 1外链, 2内页）
  final int? jumpType;

  ///跳转链接
  final String? link;

  ///扩展字段json
  final Map<String, dynamic>? extraJson;

  SysNoticePayload(this.type, this.jumpType, this.link, this.extraJson);

  static SysNoticePayload? fromJson(Map<String, dynamic> json) {
    AppLogger.d('SysNoticePayload: $json');
    final type = json.getIntOrNull('type');
    final jumpType = json.getIntOrNull('jumpType');
    if(jumpType == null){
      return null;
    }

    Map? extraMap;
    final extraJson = json.getStringOrNull('extraJson');
    if (extraJson != null) {
      try {
        extraMap = jsonDecode(extraJson);
        final extra = extraMap?.getStringOrNull('extra');
        if(extra != null){
          extra.toJson()?.let((value){
            extraMap?.remove('extra');
            extraMap?.addAll(value);
          });
        }
      } catch (ex) {
        AppLogger.w('SysNoticePayload.fromJson > extraJson ex=$ex');
      }
    }
    return SysNoticePayload(
      type,
      jumpType,
      json.getStringOrNull('link'),
      extraMap?.map((key, value) => MapEntry(key.toString(), value)),
    );
  }
}
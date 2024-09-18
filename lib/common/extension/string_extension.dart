import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

extension StringExtension on String {
  bool get isSvga {
    final String extension = split('.').last.toLowerCase();
    return extension == 'svga';
  }

  String get md5String {
    var content = utf8.encode(this);
    var digest = md5.convert(content);
    return digest.toString();
  }

  DateTime? get dateTime {
    try {
      return DateUtil.getDateTime(this);
    } catch (ex) {
      AppLogger.w(ex);
      return null;
    }
  }

  Color? get color {


    return null;
  }

  String get uuid => const Uuid().v5(Uuid.NAMESPACE_URL, this);

  Future<void> copy({String? message}) async {
    await Clipboard.setData(ClipboardData(text: this));
    if (message != null && message.isEmpty) {
      return;
    }
    Loading.showToast(message ?? S.current.copySuccess);
  }
}

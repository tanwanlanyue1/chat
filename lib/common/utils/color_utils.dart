import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

///HEX颜色
extension ColorUtil on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    if (hexString.contains("rgb")) {
      String hexString0 = hexString
          .split("(")
          .last
          .replaceAll(")", "");
      if (hexString0
          .split(",")
          .length != 3) {
        return Colors.transparent;
      }

      int? r = int.tryParse(hexString0.split(",")[0]);
      int? g = int.tryParse(hexString0.split(",")[1]);
      int? b = int.tryParse(hexString0.split(",")[2]);

      return Color.fromRGBO(r!, g!, b!, 1);
    }

    if (ObjectUtil.isEmpty(hexString) == true || hexString.length < 6) {
      return Colors.transparent;
    }

    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write("ff");
    buffer.write(hexString.replaceFirst("#", ""));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  static String toHex(Color color, {bool leadingHashSign = true}) {
    return color.value.toRadixString(16).toUpperCase().replaceFirst(r"FF", "");
  }
}

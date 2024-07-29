import 'package:flutter/material.dart';

///padding
class FEdgeInsets extends EdgeInsets{

  const FEdgeInsets({
    double? all,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) : super.only(
      left: left ?? horizontal ?? all ?? 0,
      top: top ?? vertical ?? all ?? 0,
      right: right ?? horizontal ?? all ?? 0,
      bottom: bottom ?? vertical ?? all ?? 0,
  );

  static FEdgeInsets get zero => const FEdgeInsets();
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

class LightsPrayState {
  static const int length = 72; // item 数量
  final mainAxisSpacing = 13.rpx; // 主轴间距
  final crossAxisSpacing = 20.rpx; // 交叉轴间距
  final childAspectRatio = 7.0 / 6.0; // item 高宽比

  BoxConstraints listConstraints = const BoxConstraints(); // 列表约束

  // 当前显示区域
  final area = LightsPrayArea.east.obs;

  // 当前显示数据列表
  final items = <LightsPrayItem>[
    ...List.generate(length, (index) => LightsPrayItem(index: index)),
  ].obs;

  // 我的供灯模型数组
  var myLights = <LightsPrayItem>[];
}

enum LightsPrayArea {
  east(name: "正东"),
  south(name: "正南"),
  west(name: "正西"),
  north(name: "正北"),
  unknown(name: "");

  const LightsPrayArea({required this.name});

  final String name;

  static LightsPrayArea getType(int value) =>
      LightsPrayArea.values.firstWhere((activity) => activity.index == value,
          orElse: () => LightsPrayArea.unknown);
}

extension LightsPrayAreaExtension on LightsPrayArea {
  LightsPrayArea get next {
    LightsPrayArea nextValue;
    switch (this) {
      case LightsPrayArea.east:
        nextValue = LightsPrayArea.south;
        break;
      case LightsPrayArea.south:
        nextValue = LightsPrayArea.west;
        break;
      case LightsPrayArea.west:
        nextValue = LightsPrayArea.north;
        break;
      case LightsPrayArea.north:
        nextValue = LightsPrayArea.east;
        break;
      default:
        nextValue = LightsPrayArea.unknown;
        break;
    }
    return nextValue;
  }
}

class LightsPrayItem {
  final int index;
  LightsPrayArea area;

  LightsPrayModel? model;

  late int row; // 排
  late int column; // 号

  LightsPrayItem({
    required this.index,
    this.area = LightsPrayArea.east,
    this.model,
  }) {
    row = determineRowForIndex(index);
    column = determineColumnForRowAndIndex(row, index);
  }

  int determineRowForIndex(int index) {
    if (index < 3) {
      return 1;
    } else if (index < 7) {
      return 2;
    } else {
      return ((index - 7) ~/ 5) + 3;
    }
  }

  int determineColumnForRowAndIndex(int row, int index) {
    if (row == 1) {
      return index + 1;
    } else if (row == 2) {
      return index - 2;
    } else {
      return (index - 7) % 5 + 1;
    }
  }
}

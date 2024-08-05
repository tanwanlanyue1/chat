import 'package:collection/collection.dart';

enum OrderListType {
  going,
  cancel,
  finish;

  static OrderListType valueForIndex(int index) {
    return OrderListType.values.elementAtOrNull(index) ?? OrderListType.going;
  }

  static OrderListType valueForName(String name) {
    return OrderListType.values
            .firstWhereOrNull((element) => element.name == name) ??
        OrderListType.going;
  }
}

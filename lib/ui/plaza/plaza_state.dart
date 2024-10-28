import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';

class PlazaState {
  List tabBarList = [
    {"name": S.current.recommend},
    {"name": S.current.nearby},
    {"name": S.current.community},
  ];
  final tabIndex = 0.obs;
}

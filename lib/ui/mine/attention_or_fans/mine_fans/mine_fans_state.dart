import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class MineFansState {
  MineFansState() {
    ///Initialize variables
  }

  List<MineFans> items = [
    MineFans(
      icon: "assets/images/mine/setting.png",
      title: "金牛座的信仰牛",
      constellation: "摩羯",
      level: 5,
      fans: 1234,
      works: 95,
    ),
    MineFans(
      icon: "assets/images/mine/setting.png",
      title: "白羊座的信仰羊",
      constellation: "白羊",
    ),
  ].obs;
}

class MineFans {
  final String icon;
  final String title;
  final String constellation;
  final int level;
  final int fans;
  final int works;

  late bool isAttention;

  MineFans({
    required this.icon,
    required this.title,
    required this.constellation,
    this.level = 0,
    this.fans = 0,
    this.works = 0,
    this.isAttention = false,
  });
}

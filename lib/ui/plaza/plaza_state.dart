import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';

class PlazaState {
  List tabBarList = [
    {
      "name": S.current.recommend,
      "img": "assets/images/plaza/recommend_back.png",
    },
    {
      "name": S.current.nearby,
      "img": "assets/images/plaza/nearby_back.png",
    },
    {
      "name": S.current.community,
      "img": "assets/images/plaza/community_back.png",
    },
  ];
  final tabIndex = 0.obs;
}

import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/open/app_config_model.dart';
import 'package:guanjia/common/service/service.dart';

class DisambiguationState {
  ///解谜类型
  // List<DisambiguationType> disambiguationItem = [
  //   const DisambiguationType(
  //     icon: 'assets/images/disambiguation/divination_unselected.png',
  //     activeIcon: 'assets/images/disambiguation/divination.png',
  //   ),
  //   const DisambiguationType(
  //     icon: 'assets/images/disambiguation/take_name_unselected.png',
  //     activeIcon: 'assets/images/disambiguation/take_name.png',
  //   ),
  //   const DisambiguationType(
  //     icon: 'assets/images/disambiguation/constellation_unselected.png',
  //     activeIcon: 'assets/images/disambiguation/constellation.png',
  //   ),
  //   const DisambiguationType(
  //     icon: 'assets/images/disambiguation/fortune_unselected.png',
  //     activeIcon: 'assets/images/disambiguation/fortune.png',
  //   ),
  //   const DisambiguationType(
  //     icon: 'assets/images/disambiguation/oneiromancy_unselected.png',
  //     activeIcon: 'assets/images/disambiguation/oneiromancy.png',
  //   ),
  // ];
  ///APP配置
  RxList<Home> appHome = <Home>[].obs;

  RxInt divinationIndex = RxInt(0);
  var prevIndex = 0;
}

class DisambiguationType {

  ///未选中图标
  final String icon;

  ///已选中图标
  final String activeIcon;

  const DisambiguationType({
    required this.icon,
    required this.activeIcon,
  });

  DisambiguationType copyWith({
    String? icon,
    String? activeIcon,
    String? title,
  }) {
    return DisambiguationType(
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
    );
  }
}
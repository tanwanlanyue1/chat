import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/ui/wish_pavilion/charm/charm_background/charm_background_page.dart';
import 'package:guanjia/ui/wish_pavilion/charm/charm_page.dart';
import 'package:guanjia/ui/wish_pavilion/charm/my_charm/my_charm_page.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/homesick_mine/homesick_mine_page.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/homesick_river_page.dart';
import 'package:guanjia/ui/wish_pavilion/lights_pray/lights_pray_invitation/lights_pray_invitation_page.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/votive_sky_lantern/votive_sky_lantern_page.dart';
import 'package:guanjia/ui/wish_pavilion/lights_pray/lights_pray_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/all_sutras/all_sutras_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/buddhist_sutras_list/buddhist_sutras_list_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/chant_sutras_player/chant_sutras_player_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/choose_buddha/choose_buddha_controller.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/choose_buddha/choose_buddha_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/merit_cultivation_ranking/merit_cultivation_ranking_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/practice_detail/offer_incense_detail/offer_incense_detail_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/practice_detail/practice_detail_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/practice_detail/rosary_beads_detail/rosary_beads_detail_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/practice_detail/tribute_detail/tribute_detail_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/practice_detail/wooden_fish_detail/wooden_fish_detail_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/rosary_beads_setting/rosary_beads_setting_controller.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/rosary_beads_setting/rosary_beads_setting_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/wooden_fish_setting/wooden_fish_setting_page.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/zen_room_page.dart';

import '../app_pages.dart';

class WishPavilionPages {
  static final routes = [
    GetPage(
      name: AppRoutes.zenRoomPage,
      page: () => ZenRoomPage(),
    ),
    GetPage(
      name: AppRoutes.homesickRiverPage,
      page: () => HomesickRiverPage(),
    ),
    GetPage(
      name: AppRoutes.votiveSkyLanternPage,
      page: () => VotiveSkyLanternPage(),
    ),
    GetPage(
      name: AppRoutes.homesickMine,
      page: () => HomesickMinePage(),
    ),
    GetPage(
      name: AppRoutes.lightsPrayPage,
      page: () => LightsPrayPage(),
    ),
    GetPage(
      name: AppRoutes.lightsPrayInvitationPage,
      page: () {
        var p = Get.tryGetArgs("position");
        var d = Get.tryGetArgs("direction");

        var position = 0;
        var direction = 0;
        if (p != null && p is int) {
          position = p;
        }
        if (d != null && d is int) {
          direction = d;
        }
        return LightsPrayInvitationPage(
            position: position, direction: direction);
      },
    ),
    GetPage(
      name: AppRoutes.qingFoPage,
      page: () => const ChooseBuddhaPage(),
      binding: BindingsBuilder.put(() => ChooseBuddhaController(
            selectedId: Get.tryGetArgs('selectedId'),
            buddhaList: Get.getArgs('buddhaList', []),
          )),
    ),
    GetPage(
      name: AppRoutes.woodenFishSettingPage,
      page: () => WoodenFishSettingPage(),
    ),
    GetPage(
      name: AppRoutes.rosaryBeadsBackgroundSettingPage,
      page: () => RosaryBeadsSettingPage(),
      binding: BindingsBuilder.put(
        () =>
            RosaryBeadsSettingController(Get.tryGetArgs('currentBackgroundId')),
      ),
    ),
    GetPage(
      name: AppRoutes.buddhistSutrasListPage,
      page: () => BuddhistSutrasListPage(),
    ),
    GetPage(
      name: AppRoutes.allSutrasPage,
      page: () => AllSutrasPage(),
    ),
    GetPage(
      name: AppRoutes.practiceDetailPage,
      page: () => PracticeDetailPage(),
    ),
    GetPage(
      name: AppRoutes.offerIncenseDetailPage,
      page: () => OfferIncenseDetailPage(),
    ),
    GetPage(
      name: AppRoutes.tributeDetailPage,
      page: () => TributeDetailPage(),
    ),
    GetPage(
      name: AppRoutes.woodenFishDetailPage,
      page: () => WoodenFishDetailPage(),
    ),
    GetPage(
      name: AppRoutes.rosaryBeadsDetailPage,
      page: () => RosaryBeadsDetailPage(),
    ),
    GetPage(
      name: AppRoutes.meritListPage,
      page: () => MeritCultivationRankingPage(
        initialIndex: Get.getArgs('initialIndex', 0),
      ),
    ),
    GetPage(
      name: AppRoutes.chantSutrasPlayerPage,
      page: () => ChantSutrasPlayerPage(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.charmPage,
      page: () => CharmPage(),
    ),
    GetPage(
      name: AppRoutes.charmBackgroundPage,
      page: () => CharmBackgroundPage(),
    ),
    GetPage(
      name: AppRoutes.myCharmPage,
      page: () => MyCharmPage(),
    ),
  ];
}

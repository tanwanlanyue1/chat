import 'dart:io';

import 'package:get/get.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:guanjia/ui/home/home_controller.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:guanjia/widgets/web/web_page.dart';
import 'mine_state.dart';
import 'widgets/activation_progression.dart';

class MineController extends GetxController {
  final MineState state = MineState();

  final refreshController = RefreshController();

  late final loginService = SS.login;

  @override
  void onInit() {
    super.onInit();
  }

  void onRefresh() {
    if (loginService.isLogin) {
      loginService
          .fetchMyInfo()
          .whenComplete(() => refreshController.refreshCompleted());
    } else {
      refreshController.refreshCompleted();
    }
  }

  void onTapLogin() {
    Get.toNamed(AppRoutes.loginPage);
  }

  void onTapGoldDetails() {
    Get.toNamed(AppRoutes.mineGoldDetail);
  }

  void onTapPurchase() {
    Get.toNamed(AppRoutes.minePurchase);
  }

  void onTapItem(MineItemType type) {
    switch (type) {
      case MineItemType.accountData:
        Get.toNamed(AppRoutes.accountDataPage);
        break;
      case MineItemType.message:
        Get.toNamed(AppRoutes.mineMessage);
        break;
      case MineItemType.feedback:
        Get.toNamed(AppRoutes.mineFeedbackPage);
        break;
      case MineItemType.setting:
        Get.toNamed(AppRoutes.mineSettingPage);
        break;
      case MineItemType.help:
        WebPage.go(
            title: '客服与帮助',
            url:
                '${AppConfig.urlHelp}?t=${DateTime.now().millisecondsSinceEpoch}');
        break;
      case MineItemType.attentionOrFans:
        break;
      case MineItemType.evaluate:
        Get.toNamed(AppRoutes.mineEvaluatePage);
        break;
      case MineItemType.jiaEvaluate:
        Get.toNamed(AppRoutes.jiaEvaluatePage);
        break;
      case MineItemType.activation:
        ActivationProgression.show();
        break;
      case MineItemType.contractDetail:
        Get.toNamed(AppRoutes.contractDetailPage, arguments: {
          'status': ContractStatus.signed,
        });
        break;
      case MineItemType.contractSign:
        Get.toNamed(AppRoutes.contractDetailPage, arguments: {
          'status': ContractStatus.unsigned,
        });
        break;
      case MineItemType.generateContract:
        Get.toNamed(AppRoutes.contractGeneratePage);
        break;
      case MineItemType.contractList:
        Get.toNamed(AppRoutes.contractListPage);
        break;
      case MineItemType.haveSeen:
        Get.toNamed(AppRoutes.haveSeenPage);
        break;
      case MineItemType.serviceCharge:
        Get.toNamed(AppRoutes.mineServiceChargePage);
        break;
      case MineItemType.teamEvaluation:
        Get.toNamed(AppRoutes.mineTeamEvaluatePage);
        break;
      case MineItemType.myTeam:
        Get.toNamed(AppRoutes.mineMyTeamPage);
        break;
    }
  }
}

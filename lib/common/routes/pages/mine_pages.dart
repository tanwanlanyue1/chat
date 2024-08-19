import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/ui/chat/message_list/message_list_controller.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/ui/chat/red_packet/red_packet_controller.dart';
import 'package:guanjia/ui/chat/red_packet/red_packet_page.dart';
import 'package:guanjia/ui/chat/transfer_money/transfer_money_controller.dart';
import 'package:guanjia/ui/chat/transfer_money/transfer_money_page.dart';
import 'package:guanjia/ui/mine/avatar/avatar_page.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_controller.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_page.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_state.dart';
import 'package:guanjia/ui/mine/have_seen/have_seen_page.dart';
import 'package:guanjia/ui/mine/identity_progression/identity_progression_page.dart';
import 'package:guanjia/ui/mine/contract_generate/contract_generate_controller.dart';
import 'package:guanjia/ui/mine/contract_generate/contract_generate_page.dart';
import 'package:guanjia/ui/mine/contract_list/contract_list_controller.dart';
import 'package:guanjia/ui/mine/contract_list/contract_list_page.dart';
import 'package:guanjia/ui/mine/mine_client/mine_client_page.dart';
import 'package:guanjia/ui/mine/mine_evaluate/jia_evaluate/jia_evaluate_page.dart';
import 'package:guanjia/ui/mine/mine_evaluate/mine_evaluate_page.dart';
import 'package:guanjia/ui/mine/mine_my_team/mine_my_team_page.dart';
import 'package:guanjia/ui/mine/mine_service_charge/mine_service_charge_page.dart';
import 'package:guanjia/ui/mine/mine_setting/binding/binding_controller.dart';
import 'package:guanjia/ui/mine/mine_setting/binding/binding_page.dart';
import 'package:guanjia/ui/mine/mine_setting/payment_password/payment_password_page.dart';
import 'package:guanjia/ui/mine/mine_setting/update_password/update_password_controller.dart';
import 'package:guanjia/ui/mine/mine_team_evaluate/mine_team_evaluate_page.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import '../app_pages.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/ui/mine/mine_message/mine_message_page.dart';
import '../../../ui/mine/mine_feedback/mine_feedback_page.dart';
import '../../../ui/mine/mine_help/mine_help_page.dart';
import '../../../ui/mine/mine_setting/about/about_page.dart';
import '../../../ui/mine/mine_setting/account_blacklist/account_blacklist_page.dart';
import '../../../ui/mine/mine_setting/account_data/account_data_page.dart';
import '../../../ui/mine/mine_setting/mine_permissions/mine_permissions_page.dart';
import '../../../ui/mine/mine_setting/mine_setting_page.dart';
import '../../../ui/mine/mine_setting/update_info/update_info_page.dart';
import '../../../ui/mine/mine_setting/update_password/update_password_page.dart';

class MinePages {
  static final routes = [
    GetPage(
      name: AppRoutes.mineFeedbackPage,
      page: () => MineFeedbackPage(),
    ),
    GetPage(
      name: AppRoutes.mineHelpPage,
      page: () => MineHelpPage(),
    ),
    GetPage(
      name: AppRoutes.mineMessage,
      page: () => MineMessagePage(),
    ),
    GetPage(
      name: AppRoutes.mineSettingPage,
      page: () => MineSettingPage(),
    ),
    GetPage(
      name: AppRoutes.accountDataPage,
      page: () => AccountDataPage(),
    ),
    GetPage(
      name: AppRoutes.updateInfoPage,
      page: () => UpdateInfoPage(
        type: Get.tryGetArgs('type'),
      ),
    ),
    GetPage(
      name: AppRoutes.updatePasswordPage,
      page: () => UpdatePasswordPage(),
      binding: BindingsBuilder.put(() => UpdatePasswordController(
            login: Get.tryGetArgs('login'),
          )),
    ),
    GetPage(
      name: AppRoutes.accountBlacklistPage,
      page: () => AccountBlacklistPage(),
    ),
    GetPage(
      name: AppRoutes.aboutPage,
      page: () => AboutPage(),
    ),
    GetPage(
      name: AppRoutes.permissions,
      page: () => MinePermissionsPage(),
    ),
    GetPage(
      name: AppRoutes.bindingPage,
      page: () => BindingPage(),
      binding: BindingsBuilder.put(() => BindingController(
            currentIndex: Get.tryGetArgs('currentIndex'),
          )),
    ),
    GetPage(
      name: AppRoutes.mineEvaluatePage,
      page: () => MineEvaluatePage(),
    ),
    GetPage(
      name: AppRoutes.jiaEvaluatePage,
      page: () => JiaEvaluatePage(),
    ),
    GetPage(
      name: AppRoutes.paymentPasswordPage,
      page: () => PaymentPasswordPage(),
    ),
    GetPage(
      name: AppRoutes.contractGeneratePage,
      page: () => const ContractGeneratePage(),
      binding: BindingsBuilder.put(ContractGenerateController.new),
    ),
    GetPage(
      name: AppRoutes.contractDetailPage,
      page: () => const ContractDetailPage(),
      binding: BindingsBuilder.put(() {
        return ContractDetailController(
          contractId: Get.getArgs('contractId', 0),
        );
      }),
    ),
    GetPage(
      name: AppRoutes.contractListPage,
      page: () => const ContractListPage(),
      binding: BindingsBuilder.put(ContractListController.new),
    ),
    GetPage(
      name: AppRoutes.identityProgressionPage,
      page: () => IdentityProgressionPage(),
    ),
    GetPage(
      name: AppRoutes.haveSeenPage,
      page: () => HaveSeenPage(),
    ),
    GetPage(
      name: AppRoutes.mineServiceChargePage,
      page: () => MineServiceChargePage(),
    ),
    GetPage(
      name: AppRoutes.mineTeamEvaluatePage,
      page: () => MineTeamEvaluatePage(),
    ),
    GetPage(
      name: AppRoutes.mineMyTeamPage,
      page: () => MineMyTeamPage(),
    ),
    GetPage(
      name: AppRoutes.mineClient,
      page: () => MineClientPage(),
    ),
    GetPage(
      name: AppRoutes.avatarPage,
      page: () => AvatarPage(),
    ),
    GetPage(
      name: AppRoutes.messageListPage,
      page: () => MessageListPage(
        conversationId: Get.getArgs('conversationId', ''),
        conversationType: Get.getArgs(
          'conversationType',
          ZIMConversationType.peer,
        ),
        isFromFriend: Get.getArgs('isFromFriend', false),
      ),
    ),
    GetPage(
      name: AppRoutes.redPacketPage,
      page: () => const RedPacketPage(),
      binding: BindingsBuilder.put(
        () => RedPacketController(
            conversationId: Get.getArgs('conversationId', ''),
            conversationType: Get.getArgs(
              'conversationType',
              ZIMConversationType.peer,
            )),
      ),
    ),
    GetPage(
      name: AppRoutes.transferMoneyPage,
      page: () => const TransferMoneyPage(),
      binding: BindingsBuilder.put(
        () => TransferMoneyController(
          userId: Get.getArgs('userId', 0),
        ),
      ),
    ),
  ];
}

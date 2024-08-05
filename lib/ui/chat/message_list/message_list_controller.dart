import 'package:get/get.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_list_state.dart';

class MessageListController extends GetxController {
  final MessageListState state;

  MessageListController({
    required String conversationId,
    required ZIMConversationType conversationType,
  }) : state = MessageListState(
          conversationId: conversationId,
          conversationType: conversationType,
        );

  void showMoreBottomSheet() {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: [
          '查看个人主页',
          '关注',
        ],
        onTap: (index) {},
      ),
    );
  }
}

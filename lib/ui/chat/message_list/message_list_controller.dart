import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_feature_panel.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../common/utils/permissions_utils.dart';
import 'message_list_state.dart';

class MessageListController extends GetxController {
  final MessageListState state;

  final recordProcessor = ZIMKitRecordStatus();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    recordProcessor.register();
  }

  @override
  void onClose() {
    super.dispose();
    recordProcessor.unregister();
    scrollController.dispose();
  }

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

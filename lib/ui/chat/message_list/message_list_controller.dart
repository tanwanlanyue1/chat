import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/ui/chat/message_list/widgets/chat_call_dialog.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'message_list_state.dart';
import 'widgets/chat_input_view.dart';

class MessageListController extends GetxController {
  final MessageListState state;

  final recordProcessor = ZIMKitRecordStatus();
  final scrollController = ScrollController();
  ValueNotifier<ZIMKitConversation>? _conversationNotifier;
  final chatInputViewKey = GlobalKey<ChatInputViewState>();

  @override
  void onInit() {
    super.onInit();
    recordProcessor.register();
    _conversationNotifier =
        ZIMKit().getConversation(state.conversationId, state.conversationType);
    _conversationNotifier?.addListener(_onConversationChanged);
    _onConversationChanged();
  }

  void _onConversationChanged() {
    state.conversationRx.value = _conversationNotifier?.value;
  }

  @override
  void onClose() {
    super.onClose();
    _conversationNotifier?.removeListener(_onConversationChanged);
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

  ///音视频通话呼出前调用
  Future<bool> onWillOutgoingCall(bool isVideoCall) async{
    var hasPermission = false;
    if (isVideoCall) {
      hasPermission = await PermissionsUtils.requestPermissions([
        Permission.camera,
        Permission.microphone,
      ], hintText: '需要开启相机和麦克风权限');
    } else {
      hasPermission = await PermissionsUtils.requestPermission(
        Permission.microphone,
        hintText: '需要开启麦克风权限',
      );
    }
    if(!hasPermission){
      return false;
    }

    //发起聊天
    final result = await ChatCallDialog.show(isVideoCall: isVideoCall);


    return result == true;
  }

  void showMoreBottomSheet() {
    Get.bottomSheet(
      CommonBottomSheet(
        titles: [
          '查看个人主页',
          '关注',
        ],
        onTap: (index) {
          switch(index){
            case 0:
              Get.toNamed(AppRoutes.userCenterPage, arguments: {
                'userId': state.conversationId,
              });
              break;
            case 1:
              //TODO 关注
              break;
          }
        },
      ),
    );
  }
}

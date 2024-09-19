import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/network/api/im_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/custom/message_extension.dart';
import 'package:guanjia/ui/chat/custom/message_red_packet_content.dart';
import 'package:guanjia/ui/chat/message_list/message_order_part.dart';
import 'package:guanjia/ui/chat/utils/chat_user_info_cache.dart';
import 'package:guanjia/ui/order/mixin/order_operation_mixin.dart';
import 'package:guanjia/ui/plaza/user_center/user_center_controller.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:guanjia/widgets/loading.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../common/network/network.dart';
import 'message_list_state.dart';
import 'widgets/chat_feature_panel.dart';
import 'widgets/chat_input_view.dart';

class MessageListController extends GetxController
    with UserAttentionMixin, GetAutoDisposeMixin, OrderOperationMixin {
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

    //监听用户信息，更新底部actions列表
    autoDisposeWorker(everAll([state.userInfoRx, state.orderRx], (_) {
      final userInfo = state.userInfoRx();
      final order = state.orderRx();
      final actions = [...ChatFeatureAction.values];
      //当前登录用户不是普通用户或者对方是普通用户，则不显示发起约会
      if (!SS.login.userType.isUser || userInfo?.type.isUser == true) {
        actions.remove(ChatFeatureAction.date);
      }

      //有进行中的订单，不能发起约会
      if (order != null &&
          ![OrderStatus.cancel, OrderStatus.finish, OrderStatus.timeOut].contains(order.state)) {
        actions.remove(ChatFeatureAction.date);
      }

      if (actions.length != state.featureActionsRx.length) {
        state.featureActionsRx.value = actions;
      }
    }));

    ///监听订单变更，刷新订单
    autoCancel(SS.inAppMessage.listen((message) {
      final content = message.orderUpdateContent;
      if (content == null) {
        return;
      }
      //只关注与当前会话相关的订单
      final ids = [content.requestId, content.receiveId, content.introducerId];
      if (ids.contains(SS.login.userId) && ids.contains(userId)) {
        fetchOrder();
      }
    }));

    _fetchData();
  }

  ///聊天的用户ID
  int get userId => int.parse(state.conversationId);

  void _fetchData() async {
    final responses = await Future.wait([
      //获取用户关注状态
      getIsAttention(userId),
      //用户信息
      UserApi.info(uid: userId),
      //订单信息
      fetchOrder(),
    ]);

    //用户信息
    final userResponse = responses[1] as ApiResponse<UserModel>;
    if (userResponse.isSuccess) {
      state.userInfoRx.value = userResponse.data;
    }
  }

  void _onConversationChanged() {
    state.conversationRx.value = _conversationNotifier?.value;
  }

  ///点击红包
  void onTapRedPacket(ZIMKitMessage message){
    final content = message.redPacketContent;
    if(content == null){
      return;
    }
    if(message.isRevokeMessage){
      message.isRevokeMessage = false;
      ///撤回红包
      _actionRedPacket(message, true);
      return;
    }
    if(!message.isInsertMessage){
      ///领取红包
      _actionRedPacket(message, false);
    }
  }

  ///红包操作
  ///- isRevoke true撤回，false领取
  void _actionRedPacket(ZIMKitMessage message, bool isRevoke) async{

    //发起方点击无操作
    if (!isRevoke && message.isMine) {
      return;
    }

    //接收方点击无操作
    if (isRevoke && !message.isMine) {
      return;
    }

    final content = message.redPacketContent;
    if (content == null || content.status != 0) {
      AppLogger.d('红包状态(Msg)： ${content?.status}');
      return;
    }

    if (!message.isRedPacketReceivable) {
      AppLogger.d('红包状态(localExt)： ${message.localExtendedData.value}');
      return;
    }

    MessageRedPacketLocal? newLocal;
    Loading.show();
    ApiResponse<void> response;
    if(isRevoke){
      response = await IMApi.withdrawRedEnvelopes(
        msgId: message.info.messageID.toString(),
        number: content.number,
      );
    }else{
      response = await IMApi.receiveRedEnvelopes(
        msgId: message.info.messageID.toString(),
        number: content.number,
      );
    }

    Loading.dismiss();
    if (response.isSuccess) {
      newLocal = MessageRedPacketLocal(
        status: isRevoke ? 2 : 1,
        receiveTime: DateTime.now(),
      );
    } else {
      response.showErrorMessage();

      ///状态 0待领取 1已领取 2已撤回 3已过期
      final codeMapStatus = {
        3101: 1,
        3102: 3,
        3103: 2,
      };
      final newStatus = codeMapStatus[response.code];
      DateTime? dateTime;

      //已领取，获取领取时间
      if (newStatus == 1) {
        final detailResp = await IMApi.getRedEnvelope(
          msgId: message.info.messageID.toString(),
          number: content.number,
        );
        if (detailResp.isSuccess) {
          final receiveTime = detailResp.data?.receiveTime;
          dateTime = receiveTime?.let(DateTime.fromMillisecondsSinceEpoch);
        }
      }
      if(newStatus != null){
        newLocal = MessageRedPacketLocal(
          status: newStatus,
          receiveTime: dateTime ?? DateTime.now(),
        );
      }
    }
    if (newLocal != null) {
      message.setRedPacketLocal(newLocal);
    }
  }


  @override
  void onClose() {
    super.onClose();
    _conversationNotifier?.removeListener(_onConversationChanged);
    recordProcessor.unregister();
    scrollController.dispose();
    ChatUserInfoCache().delete(userId.toString());
    ChatUserInfoCache().delete(SS.login.userId.toString());
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
          S.current.viewPersonalHomepage,
          isAttentionRx.isTrue ? S.current.unfollow : S.current.attention,
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(AppRoutes.userCenterPage, arguments: {
                'userId': userId,
              });
              break;
            case 1:
              toggleAttention(userId);
              break;
          }
        },
      ),
    );
  }
}

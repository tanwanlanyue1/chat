import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/spacing.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'session_list_controller.dart';

///会话列表
class SessionListView extends StatefulWidget {
  const SessionListView({super.key});

  @override
  State<SessionListView> createState() => _SessionListViewState();
}

class _SessionListViewState extends State<SessionListView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(SessionListController());
  final state = Get.find<SessionListController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx((){
      if(state.isReadyRx()){
        return ZIMKitConversationListView(
          onPressed: (context, conversation, defaultAction) {
            Get.to(() => ZIMKitMessageListPage(
              conversationID: conversation.id,
              conversationType: conversation.type,
            ));
          },
        );
      }
      return Spacing.blank;
    });
  }

  @override
  bool get wantKeepAlive => true;
}

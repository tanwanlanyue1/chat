import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/contact/contact_view.dart';
import 'package:guanjia/ui/chat/conversation_list/conversation_list_view.dart';

import 'chat_controller.dart';

///聊天TAB页
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(ChatController());
  final state = Get.find<ChatController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(S.current.chat),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        bottom: TabBar(
          controller: controller.tabController,
          labelStyle: AppTextStyle.fs14m,
          labelColor: AppColor.primary,
          unselectedLabelColor: AppColor.black92,
          tabs: [
            Tab(text: S.current.message),
            Tab(text: S.current.contact),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          ConversationListView(),
          ContactView(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

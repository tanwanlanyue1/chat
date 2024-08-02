import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}

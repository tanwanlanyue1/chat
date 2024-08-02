import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chat_state.dart';

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ChatState state = ChatState();
  late final tabController = TabController(length: 2, vsync: this);
}

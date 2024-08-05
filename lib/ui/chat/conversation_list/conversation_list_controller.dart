import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'conversation_list_state.dart';

class ConversationListController extends GetxController
    with GetAutoDisposeMixin {
  final ConversationListState state = ConversationListState();
  final scrollController = ScrollController();
  Completer? _loadMoreCompleter;
  final _connectCompleter = Completer<bool>();

  @override
  void onInit() {
    super.onInit();
    fetchConversationList();
    if (ZIMKitCore.instance.connectionState == ZIMConnectionState.connected) {
      _connectCompleter.complete(true);
    } else {
      autoCancel(
        ZIMKit().getConnectionStateChangedEventStream().listen(
          (event) {
            if (!_connectCompleter.isCompleted &&
                ZIMKitCore.instance.connectionState ==
                    ZIMConnectionState.connected) {
              _connectCompleter.complete(true);
            }
          },
        ),
      );
    }

    scrollController.addListener(_onScroll);
  }

  void fetchConversationList() async {
    try {
      await _connectCompleter.future;
      state.loadStatusRx.value = RxStatus.loading();
      final notifier = await ZIMKit().getConversationListNotifier();
      state.conversationListNotifier.dispose();
      notifier.insert(0, state.sysNoticeConversation, notify: false);
      state.conversationListNotifier = notifier;
      state.loadStatusRx.value = RxStatus.success();
    } catch (ex) {
      AppLogger.w(ex);
      state.loadStatusRx.value = RxStatus.error();
    }
  }

  Future<void> _onScroll() async {
    if (_loadMoreCompleter == null || _loadMoreCompleter!.isCompleted) {
      if (scrollController.position.pixels >=
          0.8 * scrollController.position.maxScrollExtent) {
        _loadMoreCompleter = Completer();
        if (0 == await ZIMKit().loadMoreConversation()) {
          scrollController.removeListener(_onScroll);
        }
        _loadMoreCompleter!.complete();
      }
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}

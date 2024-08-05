import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/paging/default_status_indicators/first_page_error_indicator.dart';
import 'package:guanjia/common/paging/default_status_indicators/first_page_progress_indicator.dart';
import 'package:guanjia/common/paging/default_status_indicators/no_items_found_indicator.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import 'conversation_list_controller.dart';
import 'widgets/conversation_list_tile.dart';

///会话列表
class ConversationListView extends StatefulWidget {
  const ConversationListView({super.key});

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(ConversationListController());
  final state = Get.find<ConversationListController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ObxValue((statusRx) {
      final status = statusRx();
      if (status.isLoading) {
        return const FirstPageProgressIndicator();
      }
      if (status.isError) {
        return FirstPageErrorIndicator(
          title: '加载失败',
          onTryAgain: () {
            setState(() {});
          },
        );
      }
      if (status.isEmpty) {
        return const NoItemsFoundIndicator(title: '暂无消息');
      }

      return ValueListenableBuilder(
        valueListenable: state.conversationListNotifier,
        builder: (_, list, __) {
          return LayoutBuilder(
            builder: (context, BoxConstraints constraints) {
              return CustomScrollView(
                controller: controller.scrollController,
                cacheExtent: constraints.maxHeight * 3,
                slivers: [
                  SliverList.separated(
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      final conversation = list[index];
                      return ValueListenableBuilder(
                        valueListenable: conversation,
                        builder: (_, conversation, __) {
                          return ConversationListTile(
                            conversation: conversation,
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) {
                      return Divider(height: 0, indent: 75.rpx);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    }, state.loadStatusRx);
  }

  @override
  bool get wantKeepAlive => true;
}

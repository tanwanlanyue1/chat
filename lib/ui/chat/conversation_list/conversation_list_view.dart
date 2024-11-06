import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/paging/default_status_indicators/first_page_error_indicator.dart';
import 'package:guanjia/common/paging/default_status_indicators/first_page_progress_indicator.dart';
import 'package:guanjia/common/paging/default_status_indicators/no_items_found_indicator.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_user_manager.dart';
import 'package:guanjia/widgets/spacing.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'conversation_list_controller.dart';
import 'widgets/conversation_list_tile.dart';
import 'widgets/conversation_notice_tile.dart';

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
    return VisibilityDetector(
      key: const Key('ConversationListView'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          ChatUserManager().startSync();
        } else {
          ChatUserManager().stopSync();
        }
      },
      child: ObxValue((statusRx) {
        final status = statusRx();
        if (status.isLoading) {
          return const FirstPageProgressIndicator();
        }
        if (status.isError) {
          return FirstPageErrorIndicator(
            title: S.current.loadFail,
            onTryAgain: () {
              setState(() {});
            },
          );
        }
        if (status.isEmpty) {
          return NoItemsFoundIndicator(title: S.current.noMessage);
        }

        return ValueListenableBuilder(
          valueListenable: state.conversationListNotifier,
          builder: (_, list, __) {
            //系统消息置顶
            // list = list.sorted((a, b) {
            //   if (b.value.id == AppConfig.sysUserId) {
            //     return 1;
            //   }
            //   return 0;
            // });
            return LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                return SlidableAutoCloseBehavior(
                  child: CustomScrollView(
                    controller: controller.scrollController,
                    cacheExtent: constraints.maxHeight * 3,
                    slivers: [
                      buildSysNotice(),
                      SliverList.builder(
                        itemCount: list.length,
                        itemBuilder: (_, index) {
                          final conversation = list[index];
                          return ValueListenableBuilder(
                            valueListenable: conversation,
                            builder: (_, conversation, __) {
                              return ConversationListTile(
                                  conversation: conversation);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }, state.loadStatusRx),
    );
  }

  Widget buildSysNotice() {
    return SliverToBoxAdapter(
      child: ObxValue((dataRx) {
        final data = dataRx();
        if (data != null) {
          return ConversationNoticeTile(model: data);
        }
        return Spacing.blank;
      }, SS.inAppMessage.latestSysNoticeRx),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

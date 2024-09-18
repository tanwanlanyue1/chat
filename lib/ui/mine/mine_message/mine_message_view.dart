import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/spacing.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'mine_message_controller.dart';
import 'widgets/mine_message_list_tile.dart';

///我的-消息列表
class MineMessageView extends StatelessWidget {
  ///0系统消息，6系统公告
  final int type;

  const MineMessageView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MineMessageController(type: type),
      global: false,
      builder: (controller) {
        return SmartRefresher(
          controller: controller.pagingController.refreshController,
          onRefresh: controller.pagingController.onRefresh,
          child: PagedListView.separated(
            padding: FEdgeInsets(horizontal: 16.rpx, vertical: 8.rpx),
            pagingController: controller.pagingController,
            builderDelegate: DefaultPagedChildBuilderDelegate<MessageModel>(
              pagingController: controller.pagingController,
              itemBuilder: (_, item, index) {
                return MineMessageListTile(
                  item: item,
                  onTap: () {
                    controller.onTapMessage(item);
                  },
                );
              },
            ),
            separatorBuilder: (_, index) => Spacing.h12,
          ),
        );
      },
    );
  }
}

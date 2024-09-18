import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'mine_message_controller.dart';
import 'mine_message_view.dart';

///我的-消息

class MineMessagePage extends StatefulWidget {

  final int tabIndex;

  const MineMessagePage({super.key, required this.tabIndex});

  @override
  State<MineMessagePage> createState() => _MineMessagePageState();
}

class _MineMessagePageState extends State<MineMessagePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.tabIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grayBackground,
      appBar: AppBar(
        title: Text(S.current.myMessage),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        bottom: TabBar(
          controller: tabController,
          labelStyle: AppTextStyle.fs14b,
          labelColor: AppColor.primaryBlue,
          unselectedLabelColor: AppColor.grayText,
          indicatorColor: AppColor.primaryBlue,
          indicatorWeight: 2.rpx,
          tabs: [
            Obx((){
              var count = SS.inAppMessage.latestSysNoticeRx()?.systemCount ?? 0;
              if(widget.tabIndex == 0){
                count = 0;
              }
              return Tab(text: count > 0 ? '系统公告($count)':'系统公告', height: 40.rpx);
            }),
            Obx((){
              var count = SS.inAppMessage.latestSysNoticeRx()?.userCount ?? 0;
              if(widget.tabIndex == 1){
                count = 0;
              }
              return Tab(text: count > 0 ? '系统消息($count)':'系统消息', height: 40.rpx);
            }),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          MineMessageView(key: Key('sys_notice'), type: 6),
          MineMessageView(key: Key('sys_message'), type: 0),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/chat/contact/widgets/contact_list_tile.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/ui/mine/widgets/client_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'mine_client_controller.dart';

//佳丽-我的客户
class MineClientPage extends StatelessWidget {
  MineClientPage({Key? key}) : super(key: key);

  final controller = Get.put(MineClientController());
  final state = Get.find<MineClientController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.myCustomer),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: CustomScrollView(
          slivers: [
            PagedSliverList(
              pagingController: controller.pagingController,
              builderDelegate: DefaultPagedChildBuilderDelegate<UserModel>(
                pagingController: controller.pagingController,
                itemBuilder: (_, item, index) {
                  return ClientCard(
                    item: item,
                    onTap: (){
                      ChatManager().startChat(userId: item.uid);
                    },
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: GetBuilder<MineClientController>(
                id: 'bottomLength',
                builder: (_) {
                  return Visibility(
                    visible: (controller.pagingController.itemList?.length ?? 0) > 0,
                    child: Container(
                      margin: EdgeInsets.only(top: 24.rpx,bottom: 24.rpx),
                      alignment: Alignment.center,
                      child: Text("共${controller.pagingController.itemList?.length}位客户",style: AppTextStyle.fs12m.copyWith(color: AppColor.black999),),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/utils/chat_manager.dart';
import 'package:guanjia/ui/mine/widgets/client_card.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:guanjia/widgets/ground_glass.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'have_seen_controller.dart';

///谁看过我
class HaveSeenPage extends StatelessWidget {
  HaveSeenPage({Key? key}) : super(key: key);

  final controller = Get.put(HaveSeenController());
  final state = Get.find<HaveSeenController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.whoSeenMe),
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
      backgroundColor: AppColor.grayF7,
      body: Stack(
        children: [
          buildClient(),
          GroundGlass(),
        ],
      ),
    );
  }

  //非VIP
  Widget buildNoVip(){
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 36.rpx),
          child: AppImage.asset("assets/images/mine/warning.png",width: 120.rpx,height: 120.rpx,),
        ),
        Text(S.current.seenVip,style: AppTextStyle.fs16b.copyWith(color: AppColor.gray5,height: 1.4),textAlign: TextAlign.center,),
        Button(
          onPressed: (){
            state.vip.value = true;
          },
          margin: EdgeInsets.all(37.rpx),
          child: Text(S.current.goNowToVIP,style: AppTextStyle.fs16m.copyWith(color: Colors.white),),
        )
      ],
    );
  }

  //客户列表
  Widget buildClient(){
    return SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: CustomScrollView(
          slivers: [
            PagedSliverList(
              pagingController: controller.pagingController,
              builderDelegate: DefaultPagedChildBuilderDelegate<VisitList>(
                pagingController: controller.pagingController,
                itemBuilder: (_, item, index) {
                  return ClientCard(
                    item: item.userInfo,
                    visitTime: item.visitTime,
                    show: !(index + 1 == controller.pagingController.length),
                    onTap: (){
                      ChatManager().startChat(userId: item.userInfo!.uid);
                    },
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: GetBuilder<HaveSeenController>(
                id: 'bottomLength',
                builder: (_) {
                  return Visibility(
                    visible: controller.pagingController.length > 0,
                    child: Container(
                      margin: EdgeInsets.only(top: 24.rpx,bottom: 24.rpx),
                      alignment: Alignment.center,
                      child: Text(S.current.haveTotalChecked(controller.pagingController.length),style: AppTextStyle.fs12m.copyWith(color: AppColor.black999),),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
    );
  }
}

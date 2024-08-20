import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/chat/message_list/message_list_page.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'dating_hall_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// 推荐
class DatingHallView extends StatelessWidget {
  DatingHallView({super.key});

  final controller = Get.put(RectifyTheWorkplaceController());
  final state = Get.find<RectifyTheWorkplaceController>().state;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        buildSpeedDating(),
        Expanded(
          child: hallItem(),
        ),
      ],
    );
  }

  ///速配
  Widget buildSpeedDating(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.rpx).copyWith(left: 15.rpx),
      height: 92.rpx,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [//rgba(34, 110, 240, 0.3)
            Color(0x4D226EF0),
            Color(0x00BD3CFF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: List.generate(state.speedDating.length, (i) => Expanded(
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AppAssetImage(state.speedDating[i]['image']),
                    fit: BoxFit.fitWidth
                  ),
                borderRadius: BorderRadius.circular(8.rpx)
              ),
              height: 70.rpx,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: 15.rpx),
              padding: EdgeInsets.only(left: 8.rpx),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.speedDating[i]['name'],style: AppTextStyle.fs22b.copyWith(color: Colors.white),),
                  Text(state.speedDating[i]['subtitle'],style: AppTextStyle.fs10m.copyWith(color: Colors.white),),
                ],
              ),
            ),
            onTap: (){},
          ),
        )),
      ),
    );
  }

  ///交友大厅列表
  Widget hallItem(){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.rpx),
            height: 45.rpx,
            child: Row(
              children: [//onTapFiltrate
                Text("交友大厅",style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),),
                const Spacer(),
                GestureDetector(
                  onTap: controller.onTapFiltrate,
                  child: Text("筛选",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray5),),
                ),
                GestureDetector(
                  onTap: controller.onTapFiltrate,
                  child: const Icon(Icons.arrow_drop_down_sharp,color: Colors.grey,),
                ),
              ],
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: controller.pagingController.refreshController,
              onRefresh: controller.pagingController.onRefresh,
              child: PagedListView(
                pagingController: controller.pagingController,
                builderDelegate: DefaultPagedChildBuilderDelegate<RecommendModel>(
                  pagingController: controller.pagingController,
                  itemBuilder: (_, item, index) {
                    return friendsItem(item);
                  },
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  //交友项
  Widget friendsItem(RecommendModel item){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.rpx,horizontal: 16.rpx),
      // color: AppColor.scaffoldBackground,
      margin: EdgeInsets.only(bottom: 8.rpx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.userCenterPage,arguments: {'userId': item.uid}),
            child: Container(
              margin: EdgeInsets.only(right: 8.rpx),
              child: AppImage.network(item.avatar ?? '',width: 100.rpx,height: 100.rpx,borderRadius: BorderRadius.circular(8.rpx),),
            ),
          ),
          Expanded(child: SizedBox(
            height: 100.rpx,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(item.nickname ?? '',style: AppTextStyle.fs16m.copyWith(color: AppColor.gray5),maxLines: 1,overflow: TextOverflow.ellipsis,),
                Row(
                  children: [
                    Text("${item.age ?? ''}岁 ",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                    Expanded(child: Text("| ${item.style ?? ''}",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                  ],
                ),
                item.images != null ?
                Row(
                  children: List.generate(jsonDecode(item.images).length > 3 ? 3 : jsonDecode(item.images).length, (index) => Container(
                    margin: EdgeInsets.only(right: 6.rpx),
                    child: AppImage.network(jsonDecode(item.images)[index],width: 40.rpx,height: 40.rpx,borderRadius: BorderRadius.circular(4.rpx),),
                  )),
                ):
                Container(),
              ],
            ),
          )),
          Button.stadium(
            onPressed: (){
              MessageListPage.go(userId: item.uid!);
            },
            width: 82.rpx,
            height: 28.rpx,
            backgroundColor: item.gender == 2 ? AppColor.purple6 : AppColor.textBlue,
            child: Text(S.current.getTouchWith,style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
          )
        ],
      ),
    );
  }
}

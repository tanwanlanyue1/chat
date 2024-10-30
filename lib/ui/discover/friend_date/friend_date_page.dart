import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/occupation_widget.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'friend_date_controller.dart';
import 'widget/tab_decoration.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

///发现-征友约会
class FriendDatePage extends StatelessWidget {
  FriendDatePage({super.key});

  final controller = Get.put(FriendDateController());
  final state = Get.find<FriendDateController>().state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.rpx).copyWith(top: 8.rpx),
      child: Column(
        children: [
          dateType(),
          classifyTab(),
          Expanded(
            child: SmartRefresher(
              controller: controller.pagingController.refreshController,
              onRefresh: controller.pagingController.onRefresh,
              child:  PagedListView(
                pagingController: controller.pagingController,
                builderDelegate: DefaultPagedChildBuilderDelegate<AppointmentModel>(
                  pagingController: controller.pagingController,
                  itemBuilder: (_, item, index) {
                    return dateCard(item,index);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //约会类型
  Widget dateType(){
    return Container(
      alignment: Alignment.centerLeft,
      height: 30.rpx,
      child: Obx(() => TabBar(
        isScrollable: true,
        controller: controller.tabController,
        labelStyle: AppTextStyle.fs14,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        indicator: TabDecoration(state.typeIndex.value == -1 ? 0 : state.typeIndex.value),
        onTap: (val) {
          state.typeIndex.value = val;
          controller.pagingController.onRefresh();
        },
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.resolveWith((states) {
          return Colors.transparent;
        }),
        labelPadding: EdgeInsets.only(right: 12.rpx),
        tabs: [
          ... List<Widget>.generate(state.typeList.length, (i) {
            return Tab(text: state.typeList[i]['title']);
          })
        ],
      )),
    );
  }

  //分类
  Widget classifyTab() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.rpx,top: 8.rpx),
      child: Obx(() =>
          Row(
            children: List<Widget>.generate(state.sortList.length, (i) =>
                GestureDetector(
                  onTap: ()=> controller.setSort(i),
                  child: Container(
                    alignment: Alignment.center,
                    height: 22.rpx,
                    padding: EdgeInsets.symmetric(horizontal: 10.rpx),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.rpx),
                      color: state.sortIndex.contains(state.sortList[i]['type'])
                          ? Colors.white
                          : AppColor.black20.withOpacity(0.2),
                    ),
                    child: Text("${state.sortList[i]['name']}",
                      style: AppTextStyle.fs12.copyWith(color: state.sortIndex.contains(state.sortList[i]['type'])
                          ? AppColor.black20
                          : Colors.white,height: 1.0
                      ),),
                  ),
                ),).separated(Spacing.w8).toList(growable: false),
          )),
    );
  }

  //约会卡片
  Widget dateCard(AppointmentModel item,int index){
    return GestureDetector(
      onTap: ()=> controller.onTapParticipation(item),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.rpx),
                border: Border.all(
                  width: 0.5.rpx,
                  color: AppColor.grayText.withOpacity(0.2),
                )
            ),
            height: 120.rpx,
            margin: EdgeInsets.only(bottom: 8.rpx),
            child: Row(
              children: [
                SizedBox(width: 110.rpx),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.rpx),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: (item.userInfo?.nameplate != null && item.userInfo!.nameplate.isNotEmpty) ? 130.rpx : 170.rpx,
                              ),
                              child: Text('${item.userInfo?.nickname}'*5,style: AppTextStyle.fs16b.copyWith(color: AppColor.black20, height: 1),maxLines: 1,overflow: TextOverflow.ellipsis,),
                            ),
                            Container(
                              height: 12.rpx,
                              padding: EdgeInsets.symmetric(horizontal: 4.rpx),
                              decoration: BoxDecoration(
                                  color: item.userInfo?.gender.iconColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14.rpx)
                              ),
                              margin: EdgeInsets.only(left: 4.rpx,right: 4.rpx),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppImage.asset(item.userInfo?.gender.icon ?? '',width: 8.rpx,height: 8.rpx),
                                  SizedBox(width: 2.rpx,),
                                  Text(
                                    "${item.userInfo?.age ?? ''}",
                                    style: AppTextStyle.fs10.copyWith(color: item.userInfo?.gender.index == 1 ? AppColor.primaryBlue:AppColor.textPurple,height: 1),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: item.userInfo?.nameplate != null && item.userInfo!.nameplate.isNotEmpty,
                              child: AppImage.network(item.userInfo?.nameplate ?? '',width: 45.rpx,height: 12.rpx,fit: BoxFit.fitHeight,),
                            )
                          ],
                        ),
                        Container(
                          height: 20.rpx,
                          margin: EdgeInsets.only(top:8.rpx),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(controller.labelSplit(item.tag ?? '').length, (index) =>
                                Padding(
                                  padding: EdgeInsets.only(right: 4.rpx),
                                  child: CachedNetworkImage(
                                    imageUrl: controller.labelSplit(item.tag ?? '')[index],
                                  ),
                                )
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8.rpx),
                          child: Text(item.content ?? '',style:AppTextStyle.fs10.copyWith(
                              fontSize: 11.rpx,fontWeight: FontWeight.w300,
                              color: AppColor.black6, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis,),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            AppImage.asset("assets/images/discover/location.png",width: 16.rpx,height: 16.rpx,),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 2.rpx,left: 2.rpx),
                                child: Text("${item.location} ${item.distance ?? 0}km",style: AppTextStyle.fs10.copyWith(color: AppColor.black92),maxLines: 1,overflow: TextOverflow.ellipsis,),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.rpx),
                                color: Colors.white.withOpacity(0.3),
                              ),
                              height: 20.rpx,
                              alignment: Alignment.center,
                              child: Text("${CommonUtils.timestamp(item.startTime, unit: 'MM/dd HH:00')} - ${CommonUtils.timestamp(item.endTime, unit: 'MM/dd HH:00')}",
                                  style: AppTextStyle.fs10r.copyWith(color: AppColor.black92)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0.rpx,
            child: Container(
              width: 110.rpx,
              height: 119.rpx,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.rpx),
                  bottomLeft: Radius.circular(12.rpx),
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: AppImage.network(
                item.userInfo?.avatar ?? '',
                fit: BoxFit.cover,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.rpx),
                  bottomLeft: Radius.circular(12.rpx),
                  topRight: Radius.circular(12.rpx),
                  bottomRight: Radius.circular(24.rpx),
                ),
              ),
            ),
          ),
          Positioned(
            top: 1.rpx,
            child: InkWell(
              onTap: (){
                Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.uid});
              },
              child: AppImage.asset(
                width: 110.rpx,
                height: 119.rpx,
                'assets/images/discover/head_back.png',
                fit: BoxFit.fitWidth,
                // fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 9.rpx,
            child: Container(
              // width: 70.rpx,
              height: 28.rpx,
              padding: EdgeInsets.symmetric(horizontal: 8.rpx),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.gradientBegin,
                    AppColor.gradientEnd,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                      color: AppColor.purple8D.withOpacity(0.8),
                      blurRadius: 4.rpx,
                      offset: Offset(1.rpx, 0),
                      inset: true
                  ),
                  BoxShadow(
                      color: AppColor.purpleE1.withOpacity(0.8),
                      blurRadius: 4.rpx,
                      offset: Offset(-1.rpx, 0),
                      inset: true
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.rpx),
                  bottomLeft: Radius.circular(12.rpx),
                  topRight: Radius.circular(14.rpx),
                  bottomRight: Radius.circular(14.rpx),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/plaza/friend_date.json',width: 12.rpx,height: 12.rpx),
                  SizedBox(width: 2.rpx,),
                  Text(controller.typeTitle(item.type ?? 1),style: AppTextStyle.fs10m.copyWith(color: Colors.white),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

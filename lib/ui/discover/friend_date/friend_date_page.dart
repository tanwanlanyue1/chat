import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'friend_date_controller.dart';
import 'widget/tab_decoration.dart';

///发现-征友约会
class FriendDatePage extends StatelessWidget {
  FriendDatePage({Key? key}) : super(key: key);

  final controller = Get.put(FriendDateController());
  final state = Get.find<FriendDateController>().state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.rpx).copyWith(left: 0),
      child: SmartRefresher(
        controller: controller.pagingController.refreshController,
        onRefresh: controller.pagingController.onRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: dateType()
            ),
            SliverToBoxAdapter(
                child: classifyTab()
            ),
            PagedSliverList(
              pagingController: controller.pagingController,
              builderDelegate: DefaultPagedChildBuilderDelegate<AppointmentModel>(
                pagingController: controller.pagingController,
                itemBuilder: (_, item, index) {
                  return dateCard(item,index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //约会类型
  Widget dateType(){
    return Container(
      height: 40.rpx,
      margin: EdgeInsets.only(top: Get.mediaQuery.padding.top+24.rpx),
      alignment: Alignment.centerLeft,
      child: Obx(() => TabBar(
        isScrollable: true,
        controller: controller.tabController,
        labelStyle: AppTextStyle.fs14b,
        labelColor: AppColor.black20,
        unselectedLabelColor: AppColor.grayText,
        indicator: TabDecoration(state.typeIndex.value == -1 ? 0 : state.typeIndex.value),
        onTap: (val) {
          state.typeIndex.value = val;
          controller.pagingController.onRefresh();
        },
        tabs: [
          ... List<Widget>.generate(state.typeList.length, (i) {
            return  Tab(text: state.typeList[i]['title'], height: 40.rpx);
          })
        ],
      )),
    );
  }

  //分类
  Widget classifyTab() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.rpx,left: 16.rpx,top: 8.rpx),
      child: Obx(() =>
          Row(
            children: List<Widget>.generate(state.sortList.length, (i) =>
                GestureDetector(
                  onTap: ()=> controller.setSort(i),
                  child: Container(
                    alignment: Alignment.center,
                    height: 22.rpx,
                    padding: EdgeInsets.symmetric(horizontal: 10.rpx),
                    decoration: ShapeDecoration(
                      shape: StadiumBorder(
                          side: BorderSide(
                            color: state.sortIndex.contains(state.sortList[i]['type']) ?
                                    AppColor.primaryBlue.withOpacity(0.8):AppColor.black92.withOpacity(0.5),
                          )
                      ),
                    ),
                    child: Text("${state.sortList[i]['name']}",
                      style: AppTextStyle.fs12m.copyWith(color: state.sortIndex.contains(state.sortList[i]['type'])
                          ? AppColor.primaryBlue
                          : AppColor.black92,
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.rpx),
          gradient: LinearGradient(
              colors: [
                state.backColor[index%4]['end'],
                state.backColor[index%4]['begin'],
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),
        margin: EdgeInsets.only(bottom: 8.rpx,left: 16.rpx),
        padding: EdgeInsets.only(bottom: 10.rpx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColor.blue65,
                        AppColor.blue65E,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.rpx),
                      bottomRight: Radius.circular(12.rpx),
                    ),
                  ),
                  height: 22.rpx,
                  padding: EdgeInsets.symmetric(horizontal: 8.rpx),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset('assets/images/plaza/friend_date.json',width: 12.rpx,height: 12.rpx),
                      SizedBox(width: 4.rpx,),
                      Text(controller.typeTitle(item.type ?? 1),style:AppTextStyle.fs12m.copyWith(color: AppColor.black20, height: 1)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 12.rpx,top: 8.rpx),
                  child: GestureDetector(
                    onTap: ()=> controller.selectMore(item.uid,item.id!),
                    child: AppImage.asset("assets/images/discover/more.png",width: 24.rpx,height: 24.rpx,),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.rpx),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.uid});
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8.rpx),
                      child: AppImage.network(item.userInfo?.avatar ?? '',width: 24.rpx,height: 24.rpx,shape: BoxShape.circle,),
                    ),
                  ),
                  Container(
                    padding: FEdgeInsets(right: 8.rpx,),
                    child: Text((item.userInfo?.nickname ?? ''),style: AppTextStyle.fs14b.copyWith(color: AppColor.black20, height: 1),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  ),
                  Row(
                    children: [
                      if(item.userInfo?.gender.index != 0)
                        Visibility(
                          visible: item.userInfo?.gender.index == 2,
                          replacement: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                          child: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                        ),
                      SizedBox(width: 8.rpx),
                      Text('${item.userInfo?.age ?? ''}',style: AppTextStyle.fs12m.copyWith(color: AppColor.black6),),
                      Container(
                        width: 4.rpx,
                        height: 4.rpx,
                        margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                        decoration: const BoxDecoration(
                          color: AppColor.grayText,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(S.current.personage,style: AppTextStyle.fs12m.copyWith(color: AppColor.black6),),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12.rpx,left: 12.rpx,right: 12.rpx),
              child: Text(item.content ?? '',style:AppTextStyle.fs16b.copyWith(color: AppColor.black20, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis,),
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx,left: 12.rpx),
              child: Text(controller.labelSplit(item.tag ?? ''),style: AppTextStyle.fs12m.copyWith(color: AppColor.primaryBlue, height: 1)),
            ),
            Padding(
              padding: FEdgeInsets(top: 12.rpx,left: 12.rpx),
              child: Row(
                children: [
                  AppImage.asset("assets/images/discover/location.png",width: 16.rpx,height: 16.rpx,),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 2.rpx),
                      child: Text("${item.location} ${item.distance ?? 0}km",style: AppTextStyle.fs12m.copyWith(color: AppColor.blackBlue),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.rpx),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    height: 20.rpx,
                    padding: EdgeInsets.symmetric(horizontal: 8.rpx),
                    margin: EdgeInsets.only(right: 12.rpx),
                    alignment: Alignment.center,
                    child: Text("${CommonUtils.timestamp(item.startTime, unit: 'MM/dd HH:00')} - ${CommonUtils.timestamp(item.endTime, unit: 'MM/dd HH:00')}",
                        style: AppTextStyle.fs10b.copyWith(color: AppColor.black20)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

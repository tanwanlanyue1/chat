import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'friend_date_controller.dart';
import 'widget/draft_dialog.dart';

///发现-征友约会
class FriendDatePage extends StatelessWidget {
  FriendDatePage({Key? key}) : super(key: key);

  final controller = Get.put(FriendDateController());
  final state = Get.find<FriendDateController>().state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.rpx),
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
                  return dateCard(item);
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
    return Obx(() {
      int current = state.typeIndex.value;
      return Padding(
        padding: EdgeInsets.only(bottom: 12.rpx),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8.rpx,
              crossAxisSpacing: 8.rpx,
              mainAxisExtent: 38.rpx
          ),
          itemCount: state.typeList.length,
          itemBuilder: (_, index) {
            var item = state.typeList[index];
            return Visibility(
              visible: index != state.typeList.length-1,
              replacement: Visibility(
                // visible: state.userInfo?.type.index == 0,
                child: CommonGradientButton(
                  text: state.typeList[index]['title'],
                  textStyle: AppTextStyle.fs14b.copyWith(color: Colors.white),
                  onTap: controller.onTapInvitation,
                ),
              ),
              child: GestureDetector(
                onTap: (){
                  state.typeIndex.value = index;
                  controller.pagingController.onRefresh();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: current == index ? AppColor.primary : AppColor.grayF7,
                    borderRadius: BorderRadius.circular(8.rpx),
                  ),
                  child: Text(
                    "${item['title']}",
                    style: TextStyle(
                        color: current == index ? Colors.white : AppColor.gray5,
                        fontWeight: current == index ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14.rpx),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  //分类
  Widget classifyTab() {
    return Obx(() =>
        Row(
      children: List.generate(state.sortList.length, (index) =>
          GestureDetector(
            onTap: (){
              state.sortIndex.value = index;
              controller.fetchPage(1);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 16.rpx),
                  child: Text("${state.sortList[index]['name']}",
                    style: TextStyle(color: index == state.sortIndex.value
                        ? AppColor.primary
                        : AppColor.gray30, fontSize: 14.rpx,
                        fontWeight: index == state.sortIndex.value ? FontWeight.bold : FontWeight.normal
                    ),),
                ),
                Container(
                  height: 2.rpx,
                  margin: EdgeInsets.only(right: 16.rpx,top: 4.rpx,bottom: 8.rpx),
                  color: index == state.sortIndex.value ? AppColor.primary : Colors.transparent,
                  child: Text("${state.sortList[index]['name']}",style: TextStyle(fontSize: 10.rpx),),
                )
              ],
            ),
          ),),
    ));
  }

  //约会卡片
  Widget dateCard(AppointmentModel item){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.circular(8.rpx),
      ),
      padding: EdgeInsets.all(16.rpx),
      margin: EdgeInsets.only(bottom: 8.rpx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":0});
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8.rpx),
                  child: AppImage.network(item.userInfo?.avatar ?? '',width: 40.rpx,height: 40.rpx,),
                ),
              ),
              SizedBox(
                height: 40.rpx,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.userInfo?.nickname ?? '',style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                    Row(
                      children: [
                        Visibility(
                          visible: item.userInfo?.gender.index == 2,
                          replacement: AppImage.asset("assets/images/mine/man.png",width: 16.rpx,height: 16.rpx,),
                          child: AppImage.asset("assets/images/mine/woman.png",width: 16.rpx,height: 16.rpx,),
                        ),
                        SizedBox(width: 8.rpx),
                        Text('${item.userInfo?.age ?? ''}',style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                        Container(
                          width: 4.rpx,
                          height: 4.rpx,
                          margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                          decoration: const BoxDecoration(
                            color: AppColor.black6,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text("个人",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray30),),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: ()=> controller.selectMore(item.uid,item.id!),
                child: Container(
                  padding: EdgeInsets.only(bottom: 16.rpx),
                  child: AppImage.asset("assets/images/discover/more.png",width: 24.rpx,height: 24.rpx,),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.scaffoldBackground,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            padding: EdgeInsets.all(8.rpx),
            margin: EdgeInsets.only(top: 9.rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.rpx,
                      height: 40.rpx,
                      margin: EdgeInsets.only(right: 12.rpx),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(8.rpx),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                      controller.typeTitle(item.type ?? 1),style: AppTextStyle.fs12b.copyWith(color: Colors.white),),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.content ?? '',style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
                            Text("#${item.tag}",style: AppTextStyle.fs12m.copyWith(color: AppColor.primary),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.rpx),
                  child: Row(
                    children: [
                      AppImage.asset("assets/images/discover/location.png",width: 16.rpx,height: 16.rpx,),
                      Container(
                        margin: EdgeInsets.only(left: 2.rpx),
                        child: Text("${item.location} ${item.distance ?? 0}km",style: AppTextStyle.fs10m.copyWith(color: AppColor.gray5),),
                      ),
                      const Spacer(),
                      Text('${DateUtil.formatDateStr(item.startTime ?? '', format: 'MM/dd HH:00')}-${DateUtil.formatDateStr(item.endTime ?? '', format: 'MM/dd HH:00')}',
                          style: AppTextStyle.fs10m.copyWith(color: AppColor.gray9)),
                    ],
                  ),
                ),
              ],
            ),
          ),//userInfo
          Visibility(
            visible: state.userInfo?.uid != item.userInfo?.uid,
            child: Container(
              width: 68.rpx,
              height: 30.rpx,
              margin: EdgeInsets.only(top: 8.rpx),
              child: CommonGradientButton(
                text: "参与",
                borderRadius: BorderRadius.circular(32.rpx),
                textStyle: AppTextStyle.fs14b.copyWith(color: Colors.white),
                onTap: ()=> controller.onTapParticipation(item),
              ),
            ),
          )
        ],
      ),
    );
  }
}

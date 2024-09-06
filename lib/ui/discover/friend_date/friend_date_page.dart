import 'package:flutter/material.dart';
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
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/api.dart';
import 'friend_date_controller.dart';

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
                visible: state.userInfo?.type.index == 0,
                child: CommonGradientButton(
                  text: state.typeList[index]['title'],
                  borderRadius: BorderRadius.circular(4.rpx),
                  textStyle: AppTextStyle.fs14b.copyWith(color: Colors.white),
                  onTap: controller.onTapInvitation,
                ),
              ),
              child: GestureDetector(
                onTap: (){
                  if(state.typeIndex.value == index){
                    state.typeIndex.value = -1;
                  }else{
                    state.typeIndex.value = index;
                  }
                  controller.pagingController.onRefresh();
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: current == index ? AppColor.primaryBlue : AppColor.grayF7,
                    borderRadius: BorderRadius.circular(4.rpx),
                  ),
                  child: Text(
                    "${item['title']}",
                    style: AppTextStyle.fs14m.copyWith(
                        color: current == index ? Colors.white : AppColor.black666,
                        fontWeight: current == index ? FontWeight.bold : null,
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
    return Padding(
      padding: EdgeInsets.only(bottom: 12.rpx),
      child: Obx(() =>
          Row(
            children: List<Widget>.generate(state.sortList.length, (i) =>
                GestureDetector(
                  onTap: ()=> controller.setSort(i),
                  child: Container(
                    alignment: Alignment.center,
                    height: 26.rpx,
                    padding: EdgeInsets.symmetric(horizontal: 10.rpx),
                    decoration: ShapeDecoration(
                      color: state.sortIndex.contains(state.sortList[i]['type']) ? AppColor.primaryBlue : Colors.transparent,
                      shape: StadiumBorder(
                          side: BorderSide(
                            color: AppColor.primaryBlue.withOpacity(0.8),
                          )
                      ),
                    ),
                    child: Text("${state.sortList[i]['name']}",
                      style: AppTextStyle.fs14m.copyWith(color: state.sortIndex.contains(state.sortList[i]['type'])
                          ? Colors.white
                          : AppColor.primaryBlue,
                      ),),
                  ),
                ),).separated(Spacing.w8).toList(growable: false),
          )),
    );
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
        children: [
          Stack(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoutes.userCenterPage,arguments: {"userId":item.uid});
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 8.rpx),
                      child: AppImage.network(item.userInfo?.avatar ?? '',width: 40.rpx,height: 40.rpx,shape: BoxShape.circle,),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: FEdgeInsets(right: 32.rpx, bottom: 8.rpx),
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
                            Text('${item.userInfo?.age ?? ''}',style: AppTextStyle.fs12m.copyWith(color: AppColor.black22),),
                            Container(
                              width: 4.rpx,
                              height: 4.rpx,
                              margin: EdgeInsets.symmetric(horizontal: 8.rpx),
                              decoration: const BoxDecoration(
                                color: AppColor.grayText,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(S.current.personage,style: AppTextStyle.fs12m.copyWith(color: AppColor.black22),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: ()=> controller.selectMore(item.uid,item.id!),
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
            margin: EdgeInsets.only(top: 8.rpx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.rpx,
                      height: 40.rpx,
                      margin: EdgeInsets.only(right: 12.rpx),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue,
                        borderRadius: BorderRadius.circular(4.rpx),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                      controller.typeTitle(item.type ?? 1),style: AppTextStyle.fs12b.copyWith(color: Colors.white,height: 1.2),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.content ?? '',style:AppTextStyle.fs14b.copyWith(color: AppColor.black20, height: 1), maxLines: 1, overflow: TextOverflow.ellipsis,),
                          Padding(
                            padding: FEdgeInsets(top: 8.rpx),
                            child: Text(controller.labelSplit(item.tag ?? ''),style: AppTextStyle.fs12b.copyWith(color: AppColor.primaryBlue, height: 1), maxLines: 1, overflow: TextOverflow.ellipsis,),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.rpx),
                  child: Row(
                    children: [
                      AppImage.asset("assets/images/discover/location.png",width: 16.rpx,height: 16.rpx,),
                      Container(
                        margin: EdgeInsets.only(left: 2.rpx),
                        child: Text("${item.location} ${item.distance ?? 0}km",style: AppTextStyle.fs10m.copyWith(color: AppColor.blackBlue),),
                      ),
                      const Spacer(),
                      Text("${CommonUtils.timestamp(item.startTime, unit: 'MM/dd HH:00')} - ${CommonUtils.timestamp(item.endTime, unit: 'MM/dd HH:00')}",
                          style: AppTextStyle.fs10b.copyWith(color: AppColor.grayText)),
                    ],
                  ),
                ),
              ],
            ),
          ),//userInfo
          if((item.serviceCharge??0) > 0 || state.userInfo?.uid != item.userInfo?.uid) Spacing.h8,
          Row(
            children: [
              Visibility(
                visible: (item.serviceCharge??0) > 0,
                child: Text(S.current.provideService,style: AppTextStyle.fs12m.copyWith(color: AppColor.black666),),
              ),
              const Spacer(),
              Visibility(
                visible: state.userInfo?.uid != item.userInfo?.uid,
                child: CommonGradientButton(
                  width: 68.rpx,
                  height: 30.rpx,
                  text: S.current.participation,
                  borderRadius: BorderRadius.circular(15.rpx),
                  textStyle: AppTextStyle.fs14b.copyWith(color: Colors.white),
                  onTap: ()=> controller.onTapParticipation(item),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

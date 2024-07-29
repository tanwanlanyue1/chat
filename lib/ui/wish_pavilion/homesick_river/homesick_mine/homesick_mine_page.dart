import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/homesick_river/widget/homesick_bottom_sheet.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/widigets/zen_room_gift_countdown.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../../../../common/network/api/model/talk_model.dart';
import 'homesick_mine_controller.dart';

///思亲-我的
class HomesickMinePage extends StatelessWidget {
  HomesickMinePage({Key? key}) : super(key: key);

  final controller = Get.put(HomesickMineController());
  final state = Get.find<HomesickMineController>().state;

  //状态
  //type 3:河灯 4：天灯 status（河灯 0:可收起 1:可重新放灯 2:已结束）（天灯 0:可完愿 1：已完愿）
  String? status(int type,int status){
    if(type == 3){
      switch(status){
        case 0:
          return '收起';
        case 1:
          return '重新放灯';
      }
    }else{
      switch(status){
        case 0:
          return '完愿';
        case 1:
          return '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.blue6,
      body: Stack(
        children: [
          AppImage.asset(
            'assets/images/wish_pavilion/homesick/mine_lamp_bg.png',
            height: 140.rpx,
          ),
          GetBuilder<HomesickMineController>(
            builder: (_){
              return SafeArea(
                child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.only(left: 16.rpx, right: 10.rpx),
                        color: Colors.transparent,
                        alignment: Alignment.centerLeft,
                        child: AppImage.asset(
                          "assets/images/plaza/back_white.png",
                          width: 24.rpx,
                          height: 24.rpx,
                        ),
                      ),
                      onTap: () {
                        Get.back();
                      },
                    ),
                    Expanded(
                      child: SmartRefresher(
                        controller: controller.pagingController.refreshController,
                        onRefresh: controller.pagingController.onRefresh,
                        child: PagedGridView(
                          padding: EdgeInsets.all(16.rpx),
                          pagingController: controller.pagingController,
                          builderDelegate: DefaultPagedChildBuilderDelegate<RecordLightModel>(
                              pagingController: controller.pagingController,
                              itemBuilder: (_, item, index) {
                                return buildItem(item: item);
                              }),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15.rpx,
                              crossAxisSpacing: 15.rpx,
                              mainAxisExtent: 180.rpx
                          ),
                        ),
                      ),
                    ),
                    bottomButton(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  //每一项灯
  Widget buildItem({required RecordLightModel item}){
    return GestureDetector(
      onTap: (){
        controller.getRecordById(item: item);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.rpx)
        ),
        padding: EdgeInsets.all(8.rpx),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    AppImage.asset(
                      'assets/images/wish_pavilion/homesick/benediction_select.png',
                      width: 20.rpx,
                      height: 20.rpx,
                    ),
                    Text(" ${item.bless}人祝福",style: AppTextStyle.fs14m.copyWith(color: AppColor.red7),),
                  ],
                ),
                AppImage.network(
                  "${item.image}",
                  width: item.type == 3 ? 90.rpx : 60.rpx,
                  height: 90.rpx,
                ),
                Visibility(
                  visible: (item.type == 3 && item.status != 2) || (item.type == 4 && item.status != 1),
                  child: GestureDetector(
                    onTap: (){
                      if(item.type == 4){
                        controller.fulfillOneWish(item);
                      }else{
                        controller.updateRecord(item: item);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: (item.type == 1 && item.status == 1) ? Colors.white : AppColor.red1,
                        border: Border.all(width: 1.5.rpx,color: (item.type == 1 && item.status == 1) ? AppColor.red1 : Colors.transparent),
                        borderRadius: BorderRadius.circular(20.rpx),
                      ),
                      width: 100.rpx,
                      height: 30.rpx,
                      alignment: Alignment.center,
                      child: Text("${status(item.type!,item.status!)}",style: AppTextStyle.fs16m.copyWith(color: Colors.white),),
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${item.createTime}",style: AppTextStyle.fs10m.copyWith(color: AppColor.gray30),),
                    Visibility(
                      visible: !(item.type == 4 && item.status == 1),
                      child: ZenRoomGiftCountdown(
                        endTime: DateUtil.getDateTime(item.endTime!)!,
                        key: Key('${item.recordId}'),
                        textStyle: AppTextStyle.fs10m.copyWith(color: AppColor.gray30),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              right: 0,
              bottom: 27.rpx,
              child: Visibility(
                visible: (item.type == 3 && item.status == 2) || (item.type == 4 && item.status == 1),
                child: Visibility(
                  visible: item.type == 4,
                  replacement: AppImage.asset(
                    "assets/images/wish_pavilion/homesick/finish.png",
                    width: 74.rpx,
                    height: 57.rpx,
                  ),
                  child: AppImage.asset(
                    "assets/images/wish_pavilion/homesick/fulfill_wish.png",
                    width: 74.rpx,
                    height: 57.rpx,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //底部按钮
  Widget bottomButton(){
    return Container(
      width: Get.width*0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27.rpx),
      ),
      margin: EdgeInsets.only(bottom: 8.rpx,top: 8.rpx),
      child: Row(
        children: List.generate(state.mineBottom.length, (index) {
          return Visibility(
            visible: index == state.mineType,
            replacement: Expanded(
              child: InkWell(
                onTap: (){
                  state.mineType = index;
                  controller.pagingController.refresh();
                  controller.update();
                },
                child: Center(
                  child: Text("${state.mineBottom[index]['title']}",style: AppTextStyle.fs16b.copyWith(color: AppColor.gray30),),
                ),
              ),
            ),
            child: Container(
              width: 114.rpx,
              height: 44.rpx,
              decoration: BoxDecoration(
                color: AppColor.red1,
                borderRadius: BorderRadius.circular(27.rpx),
              ),
              alignment: Alignment.center,
              child: Text("${state.mineBottom[index]['title']}",style: AppTextStyle.fs16b.copyWith(color: Colors.white),),
            ),
          );
        }),
      ),
    );
  }
}

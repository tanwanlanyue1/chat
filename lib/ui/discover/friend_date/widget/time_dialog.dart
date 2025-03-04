import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';

import '../release_invitation/release_invitation_controller.dart';
import 'scroll_index_page.dart';

//征友约会-选择时间
//star 开始时间
class TimeDialog extends StatelessWidget {
  bool star;
  TimeDialog({super.key,this.star = true});

  static Future<bool?> show({bool star = true}) {
    return Get.dialog(
      TimeDialog(star: star,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReleaseInvitationController>(
      id: 'timeDialog',
      builder: (controller) {
      return GestureDetector(
        onTap: (){
          Get.back();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: GestureDetector(
              onTap: (){},
              child: Container(
                width: 331.rpx,
                height: 380.rpx,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
                ),
                padding: EdgeInsets.all(16.rpx),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: AppImage.asset('assets/images/common/close.png',width: 24.rpx,height: 24.rpx,),
                      ),
                    ),
                    SizedBox(height: 8.rpx),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12.rpx,
                          crossAxisSpacing: 12.rpx,
                          mainAxisExtent: 60.rpx
                      ),
                      itemCount: controller.state.timeList.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: (){
                            controller.state.time = index;
                            controller.update(['timeDialog']);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.state.time == index ? AppColor.gradientBegin : AppColor.scaffoldBackground,
                              borderRadius: BorderRadius.circular(8.rpx),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${controller.state.timeList[index]['day']}",style: AppTextStyle.fs12m.copyWith(
                                  color: controller.state.time == index ? Colors.white : AppColor.grayText,height: 1
                                ),),
                                SizedBox(height: 10.rpx,),
                                Text("${controller.state.timeList[index]['time']}",style: AppTextStyle.fs14m.copyWith(
                                  color: controller.state.time == index ? Colors.white : AppColor.blackBlue,height: 1
                                ),),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.rpx,bottom: 17.rpx),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.current.timeSelect,style: AppTextStyle.fs14m.copyWith(color: AppColor.black92),),
                          Text("${controller.state.hour}:00",style: AppTextStyle.fs16m.copyWith(color: AppColor.black20),),
                        ],
                      ),
                    ),
                    ScrollIndexPage(
                      currentSelectIndex: controller.state.hour,
                      callBack: (val){
                        controller.state.hour = val;
                        controller.update(['timeDialog']);
                      },
                    ),
                    const Spacer(),
                    CommonGradientButton(
                      height: 50.rpx,
                      text: S.current.confirm,
                      textStyle: AppTextStyle.fs16m.copyWith(color: Colors.white),
                      onTap: (){
                        if(star){
                          controller.state.startTime = controller.state.time;
                          controller.state.startHour = controller.state.hour;
                        }else{
                          controller.state.endTime = controller.state.time;
                          controller.state.endHour = controller.state.hour;
                        }
                        controller.update(['dateFrom']);
                        Get.back();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },);
  }
}

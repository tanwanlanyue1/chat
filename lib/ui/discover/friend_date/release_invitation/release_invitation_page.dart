import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:guanjia/widgets/input_widget.dart';

import '../widget/discover_item.dart';
import '../widget/discover_radio.dart';
import '../widget/time_dialog.dart';
import 'release_invitation_controller.dart';

///发现-发布邀约
class ReleaseInvitationPage extends StatelessWidget {
  ReleaseInvitationPage({Key? key}) : super(key: key);

  final controller = Get.put(ReleaseInvitationController());
  final state = Get.find<ReleaseInvitationController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.goWithInvitation),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: Padding(
        padding: EdgeInsets.all(16.rpx),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 24.rpx),
                children: [
                  dateType(),
                  dateFrom(),
                  dateLabel(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.rpx),
              height: 50.rpx,
              child: CommonGradientButton(
                textStyle: AppTextStyle.fs14b.copyWith(color: Colors.white),
                widget: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 36.rpx),
                        child: Text(S.current.publishNow,style: AppTextStyle.fs16b.copyWith(color: Colors.white),),
                      ),
                    ),
                    Obx(() => Padding(
                      padding: EdgeInsets.only(right: 16.rpx),
                      child: Text("${S.current.publishMostOne}（${state.surplus['surplus'] ?? 0}/${state.surplus['total'] ?? 0}）",style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
                    )),
                  ],
                ),
                onTap: controller.onTapRelease,
              ),
            )
          ],
        ),
      ),
    );
  }

  //约会类型
  Widget dateType(){
    return Obx(() {
      int current = state.typeIndex.value;
      return SizedBox(
        height: 100.rpx,
        child: GridView.builder(
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
            return GestureDetector(
              onTap: (){
                state.typeIndex.value = index;
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: current == index ? AppColor.primaryBlue : Colors.white,
                  borderRadius: BorderRadius.circular(4.rpx),
                ),
                child: Text(
                  "${item['title']}",
                  style: TextStyle(
                      color: current == index ? Colors.white : AppColor.gray30,
                      fontWeight: current == index ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14.rpx),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  //约会表单
  Widget dateFrom(){
    return GetBuilder<ReleaseInvitationController>(
      id: 'dateFrom',
      builder: (_) {
      return Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 8.rpx),
            child: Text(S.current.waitOtherUsers,style: AppTextStyle.fs12r.copyWith(color: AppColor.black92),),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16.rpx),
            margin: EdgeInsets.only(bottom: 8.rpx),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            child: InputWidget(
              hintText: S.current.addDescriptionItinerary,
              maxLength: 30,
              lines: 3,
              fillColor: Colors.white,
              inputController: controller.contentController,
              hintStyle: AppTextStyle.fs14m.copyWith(color: AppColor.black92),
              counterStyle: AppTextStyle.fs14m.copyWith(color: AppColor.black92),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.rpx, color: Colors.white),
                borderRadius: BorderRadius.circular(8.rpx),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 16.rpx),
            ),
          ),
          DiscoverItem(
            title: S.current.datingSite,
            location: true,
            trailing: Text(
              S.current.required,
              style: AppTextStyle.fs14b.copyWith(color: AppColor.black92),
            ),
          ),
          DiscoverItem(
            title: S.current.startTime,
            callBack: (){
              state.time = state.startTime;
              state.hour = state.startHour;
              TimeDialog.show();
            },
            trailing: Text(
              DateUtil.formatDateStr('${controller.timeDate(time: state.startTime,hour: state.startHour)}', format: 'yyyy MM/dd HH:00'),
              style: AppTextStyle.fs14b.copyWith(color: AppColor.black20),
            ),
          ),
          DiscoverItem(
            title: S.current.endTime,
            trailing: Text(
              DateUtil.formatDateStr('${controller.timeDate(time: state.endTime,hour: state.endHour)}', format: 'yyyy MM/dd HH:00'),
              style: AppTextStyle.fs14b.copyWith(color: AppColor.black20),
            ),
            callBack: (){
              state.time = state.endTime;
              state.hour = state.endHour;
              TimeDialog.show(star: false);
            },
          ),
        ],
      );
    },);
  }

  //附加标签
  Widget dateLabel(){
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.rpx),
      ),
      padding: EdgeInsets.all(16.rpx),
      child: Column(
        children: [
          Text("${S.current.additionalLabel} (${state.labelList.length}/3)",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
          SizedBox(height: 16.rpx,),
          Container(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 12.rpx,
              runSpacing: 12.rpx,
              children: List.generate(state.label.length, (i) {
                var item = state.label[i];
                return GestureDetector(
                  onTap: () => controller.setLabel(i),
                  child: Container(
                    decoration: BoxDecoration(
                        color: state.labelList.contains(i) ? AppColor.gradientBegin : Colors.white,
                        border: Border.all(color: AppColor.gradientBegin),
                        borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 6.rpx),
                    child: Text(item.tag,style: AppTextStyle.fs14b.copyWith(color: state.labelList.contains(i) ? Colors.white : AppColor.gradientBegin),),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 32.rpx,),
          Row(
            children: [
              DiscoverRadio(
                  isSelect: state.serve.value,
                  title: S.current.noServiceCharge,
                  titleFalse: S.current.haveServiceCharge,
                  selectColor: AppColor.gradientBegin,
                  unselectColor: AppColor.gray9,
                  left: 24.rpx,
                  titleCall: (bool? val) {
                    state.serve.value = val ?? false;
                    if(val ?? false){
                      controller.serviceController.clear();
                    }
                  }
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 32.rpx),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: !state.serve.value ? AppColor.primaryBlue : AppColor.gray9,width: 1.rpx),
                      borderRadius: BorderRadius.all(Radius.circular(4.rpx))
                  ),
                  child: TextField(
                    controller: controller.serviceController,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    enabled: !state.serve.value,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8.rpx),
                      ),
                      hintText: '',
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.rpx,bottom: 1.rpx),
                            child: Text('\$',style: AppTextStyle.fs16b.copyWith(color: !state.serve.value ? AppColor.gradientBegin : AppColor.gray9),),
                          ),
                        ],
                      ),
                      prefixIconConstraints: BoxConstraints(minHeight: 34.rpx),
                      constraints: BoxConstraints(minHeight: 34.rpx),
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: AppTextStyle.fs16b.copyWith(color: AppColor.gradientBegin),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

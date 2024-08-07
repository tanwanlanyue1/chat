import 'dart:ffi';

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
                        child: Text("立即发布",style: AppTextStyle.fs16b.copyWith(color: Colors.white),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.rpx),
                      child: Text("最多发布（0/1）",style: AppTextStyle.fs12m.copyWith(color: Colors.white),),
                    ),
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
                  color: current == index ? AppColor.primary : Colors.white,
                  borderRadius: BorderRadius.circular(8.rpx),
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
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 8.rpx),
          child: Text("等待其他用户/佳丽参与一起约会吧",style: AppTextStyle.fs12m.copyWith(color: AppColor.gray9),),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 16.rpx),
          margin: EdgeInsets.only(bottom: 8.rpx),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.rpx),
          ),
          child: InputWidget(
            hintText: '添加邀约行程的简单介绍',
            maxLength: 30,
            lines: 3,
            fillColor: Colors.white,
            inputController: controller.contentController,
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.rpx, color: Colors.white),
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 16.rpx),
          ),
        ),
        DiscoverItem(
          title: "约会地点",
          trailing: Text(
            "(必选)",
            style: TextStyle(fontSize: 14.rpx, color: AppColor.gray9,fontWeight: FontWeight.bold),
          ),
        ),
        DiscoverItem(
          title: "开始时间",
          callBack: (){
            TimeDialog.show();
          },
          trailing: Text(
            "今天07/22 7:20",
            style: TextStyle(fontSize: 14.rpx, color: AppColor.gray5,fontWeight: FontWeight.bold),
          ),
        ),
        DiscoverItem(
          title: "结束时间",
          trailing: Text(
            "(必选)",
            style: TextStyle(fontSize: 14.rpx, color: AppColor.gray9,fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
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
          Text("附加标签 (${state.labelList.length}/3)",style: AppTextStyle.fs14b.copyWith(color: AppColor.gray5),),
          SizedBox(height: 16.rpx,),
          Wrap(
            spacing: 12.rpx,
            runSpacing: 12.rpx,
            children: List.generate(state.label.length, (i) {
              var item = state.label[i];
              return GestureDetector(
                onTap: () => controller.setLabel(i),
                child: Container(
                  decoration: BoxDecoration(
                      color: state.labelList.contains(i) ? AppColor.primary : Colors.white,
                      border: Border.all(color: AppColor.primary),
                      borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                  ),
                  height: 38.rpx,
                  padding: EdgeInsets.symmetric(horizontal: 12.rpx).copyWith(top: 6.rpx),
                  child: Text("$item",style: AppTextStyle.fs14b.copyWith(color: state.labelList.contains(i) ? Colors.white : AppColor.primary),),
                ),
              );
            }),
          ),
          SizedBox(height: 32.rpx,),
          Row(
            children: [
              DiscoverRadio(
                  isSelect: state.serve.value,
                  title: "无服务费",
                  titleFalse: "有服务费",
                  selectColor: AppColor.primary,
                  unselectColor: AppColor.gray9,
                  titleCall: (bool? val) {
                    state.serve.value = val ?? false;
                  }
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 32.rpx),
                  height: 34.rpx,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColor.primary,width: 2.rpx),
                      borderRadius: BorderRadius.all(Radius.circular(4.rpx))
                  ),
                  padding: EdgeInsets.all(6.rpx),
                  child: Row(
                    children: [
                      Text("\$",style: AppTextStyle.fs16b.copyWith(color: AppColor.primary),),
                      Expanded(
                        child: InputWidget(
                          hintText: '',
                          lines: 1,
                          fillColor: Colors.white,
                          textAlign: TextAlign.center,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          contentPadding: EdgeInsets.symmetric(vertical: -24.rpx,),
                          textStyle: AppTextStyle.fs16b.copyWith(color: AppColor.primary),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          inputController: controller.contentController,
                        ),
                      ),
                    ],
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

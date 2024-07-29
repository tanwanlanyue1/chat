import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/star_sign/widgets/star_sign.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/disambiguation/widgets/examine_button.dart';

import 'star_fortune_controller.dart';

///星座运势
class StarFortuneView extends StatelessWidget {
  StarFortuneView({Key? key}) : super(key: key);

  final controller = Get.put(StarFortuneController());
  final state = Get.find<StarFortuneController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StarFortuneController>(
      builder: (_){
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.rpx, bottom: 10.rpx),
              child: Text("我的星座:", style: AppTextStyle.fs16m.copyWith(color: AppColor.brown36),),
            ),
            StarSign(
              left: false,
              callBack: (val){
                state.constellation = val;
              },
            ),
            ObxValue((dataRx) =>
                Container(
                  margin: EdgeInsets.all(12.rpx),
                  child: Row(
                    children: List.generate(state.timeType.length, (i) =>
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 8.rpx),
                                height: 30.rpx,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: dataRx.value == i ?
                                      [
                                        AppColor.red8,
                                        AppColor.red58
                                      ] :
                                      [
                                        AppColor.brown2,
                                        AppColor.brown2
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(
                                        width: 1.rpx, color: AppColor.brown36,
                                        style: dataRx.value == i ? BorderStyle.none : BorderStyle.solid
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                                ),
                                child: Text("${state.timeType[i]['name']}",
                                  style: TextStyle(color: dataRx.value == i
                                      ? Colors.white
                                      : AppColor.brown36,
                                      fontSize: 12.rpx),)),
                            onTap: () {
                              dataRx.value = i;
                            },
                          ),
                        )),
                  ),
                ), state.timeIndex),
            ExamineButton(
              costGold: state.costGold != 0 ? state.costGold : 0,
              callBack: (){
                controller.getFortune();
              },
            )
          ],
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_sign_state.dart';
import 'package:guanjia/ui/disambiguation/star_sign/widgets/star_sign.dart';
import 'package:guanjia/ui/disambiguation/widgets/examine_button.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'star_pairing_controller.dart';

///星座配对
class StarPairingView extends StatelessWidget {
  StarPairingView({Key? key}) : super(key: key);

  final controller = Get.put(StarPairingController());
  final state = Get.find<StarPairingController>().state;

  showDialog({required Function(Starts) callBack}) {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: 460.rpx,
        decoration: BoxDecoration(
            color: const Color(0xffF5F1E9),
            borderRadius: BorderRadius.all(Radius.circular(12.rpx))
        ),
        padding: EdgeInsets.only(top: 24.rpx,left: 12.rpx,right: 12.rpx),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: const Icon(Icons.close,color: Color(0xff684326),),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "选择星座",
                      style: AppTextStyle.fs18b.copyWith(color: AppColor.gray5),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Text(
                    "确定",
                    style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),
                  ),
                  onTap: (){Get.back();},
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: const Color(0xffEBE7DF),
                margin: EdgeInsets.only(top: 16.rpx),
                padding: EdgeInsets.only(top: 30.rpx,left: 12.rpx,right: 12.rpx),
                child: StarSign(
                    callBack: (item) {
                      callBack(item);
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StarPairingController>(
      builder: (_){
        return Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 60.rpx),
                child:  AppImage.asset("assets/images/disambiguation/atAloss.png",width: 250.rpx,height: 250.rpx,alignment: Alignment.center,),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 120.rpx,
                                  height: 133.rpx,
                                  decoration: BoxDecoration(
                                      color: AppColor.brown14,
                                      border: Border.all(width: 1.5.rpx,color: AppColor.brown34),
                                      borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                                  ),
                                  margin: EdgeInsets.only(top: 16.rpx),
                                  padding: EdgeInsets.only(top: 20.rpx,bottom: 20.rpx),
                                  child: InkWell(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AppImage.asset(
                                          "${state.pairingBoy.icon}",
                                          width: 40.rpx,
                                          height: 40.rpx,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 8.rpx),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("${state.pairingBoy.name}",
                                                style: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),),
                                              Container(
                                                margin: EdgeInsets.only(left: 2.rpx,top: 2.rpx),
                                                child: AppImage.asset(
                                                  "assets/images/disambiguation/disambiguation_index.png",
                                                  width: 10.rpx,
                                                  height: 8.rpx,
                                                  color: AppColor.brown36,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text("${state.pairingBoy.time}",
                                          style: TextStyle(fontSize: 12.rpx,color: const Color(0xff999999)),),
                                      ],
                                    ),
                                    onTap: () {
                                      showDialog(
                                          callBack: (val) {
                                            state.pairingBoy = val;
                                            controller.update();
                                            Get.back();
                                          }
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      width: 56.rpx,
                                      height: 30.rpx,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              AppColor.red8,
                                              AppColor.red58
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                                      ),
                                      child: Text("男生",style: AppTextStyle.fs14m.copyWith(color: Colors.white),),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 47.rpx,),
                            Stack(
                              children: [
                                Container(
                                  width: 120.rpx,
                                  height: 133.rpx,
                                  decoration: BoxDecoration(
                                      color: AppColor.brown14,
                                      border: Border.all(width: 1.5.rpx,color: AppColor.brown34),
                                      borderRadius: BorderRadius.all(Radius.circular(20.rpx))
                                  ),
                                  margin: EdgeInsets.only(top: 16.rpx),
                                  padding: EdgeInsets.only(top: 20.rpx,bottom: 20.rpx),
                                  child: InkWell(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AppImage.asset(
                                          "${state.pairingGirl.icon}",
                                          width: 40.rpx,
                                          height: 40.rpx,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 8.rpx),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("${state.pairingGirl.name}",
                                                style: AppTextStyle.fs14b.copyWith(color: AppColor.brown36),),
                                              Container(
                                                margin: EdgeInsets.only(left: 2.rpx,top: 2.rpx),
                                                child: AppImage.asset(
                                                  "assets/images/disambiguation/disambiguation_index.png",
                                                  width: 10.rpx,
                                                  height: 8.rpx,
                                                  color: AppColor.brown36,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text("${state.pairingGirl.time}",
                                          style: TextStyle(fontSize: 12.rpx,color: const Color(0xff999999)),),
                                      ],
                                    ),
                                    onTap: () {
                                      showDialog(
                                          callBack: (val) {
                                            state.pairingGirl = val;
                                            Get.back();
                                            controller.update();
                                          }
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      width: 56.rpx,
                                      height: 30.rpx,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              AppColor.red8,
                                              AppColor.red58
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                                      ),
                                      child: Text("女生",style: AppTextStyle.fs14m.copyWith(color: Colors.white),),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Container(
                            width: 94.rpx,
                            height: 39.rpx,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: AppDecorations.backgroundImage("assets/images/disambiguation/pairing_back.png"),
                            ),
                            child: Text(
                              "配对", style: AppTextStyle.fs16b.copyWith(color: AppColor.red1),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ExamineButton(
                  costGold: state.costGold != 0 ? state.costGold : 0,
                  margin: EdgeInsets.only(bottom: 20.rpx),
                  callBack: controller.getPair,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

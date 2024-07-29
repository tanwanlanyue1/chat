
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/widgets/examine_button.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_form_title.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'divination_controller.dart';

import 'widgets/shaking_container.dart';

///占卜解惑
class DivinationView extends StatelessWidget {
  DivinationView({super.key});

  late DivinationController controller = Get.find<DivinationController>();
  late final state = Get
      .find<DivinationController>()
      .state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DivinationController>(
      init: DivinationController(),
      builder: (_){
        return Column(
          children: [
            DisambiguationFromTitle(title: "占卜解惑",carousel: state.carousel,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildHead(),
                    Obx(() =>
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.brown2,
                              borderRadius: BorderRadius.circular(8.rpx)
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 12.rpx,vertical: 8.rpx),
                          child: Visibility(
                            visible: state.tabBarIndex.value == 0,
                            replacement: tarot(),
                            child: bookOfChanges(),
                          ),
                        )),
                    bewilderment()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///头部
  Widget buildHead() {
    return Container(
      margin: EdgeInsets.only(left: 12.rpx,right: 12.rpx),
      child: Column(
        children: [
          Container(
            height: 80.rpx,
            padding: EdgeInsets.only(left: 16.rpx),
            decoration: BoxDecoration(
              image: AppDecorations.backgroundImage(
                  'assets/images/disambiguation/survey.png'
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppImage.asset(
                      "assets/images/disambiguation/rhombus.png",
                      width: 12.rpx,
                      height: 12.rpx,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.rpx,),
                        child: Text("一事一测", style: TextStyle(
                            fontSize: 18.rpx,
                            fontWeight: FontWeight.bold,
                            color: AppColor.brown36),)
                    ),
                    AppImage.asset(
                      "assets/images/disambiguation/rhombus.png",
                      width: 12.rpx,
                      height: 12.rpx,
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4.rpx),
                  child: Text("心里想着一件所测之事，聚精会神～",
                    style: TextStyle(fontSize: 14.rpx, color: AppColor.brown36),),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.rpx,),
          ObxValue((tabBarIndex) =>
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 50.rpx,
                        margin: EdgeInsets.only(right: 9.rpx),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: tabBarIndex.value == 0 ?
                            [AppColor.gold5, AppColor.gold9] :
                            [AppColor.brown38, AppColor.brown38],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                            borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10.rpx),
                                  child: Text('周易占卜', style: AppTextStyle.fs16b.copyWith(color: tabBarIndex.value == 0 ? AppColor.gray5 : AppColor.gray30),),
                                ),
                                Visibility(
                                  visible: tabBarIndex.value == 0,
                                  replacement: SizedBox(height: 10.rpx,),
                                  child: AppImage.asset(
                                    "assets/images/disambiguation/uparrow.png",
                                    width: 12.rpx,
                                    height: 10.rpx,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10.rpx,),
                            AppImage.asset(
                              "assets/images/disambiguation/zhouyi.png",
                              width: 70.rpx,
                              height: 44.rpx,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        tabBarIndex.value = 0;
                        controller.initYao();
                        controller.getDoubtList();
                        controller.getGold();
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        height: 50.rpx,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: tabBarIndex.value == 1 ?
                            [AppColor.gold5, AppColor.gold9] :
                            [AppColor.brown38, AppColor.brown38],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                            borderRadius: BorderRadius.all(Radius.circular(8.rpx))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 10.rpx),
                                    child: Text('塔罗牌占卜', style: AppTextStyle.fs16b.copyWith(color: tabBarIndex.value == 1 ? AppColor.gray5 : AppColor.gray30),)),
                                Visibility(
                                  visible: tabBarIndex.value == 1,
                                  replacement: SizedBox(height: 10.rpx,),
                                  child: AppImage.asset(
                                    "assets/images/disambiguation/uparrow.png",
                                    width: 12.rpx,
                                    height: 10.rpx,
                                  ),
                                ),
                              ],
                            ),
                            AppImage.asset(
                              "assets/images/disambiguation/tarot.png",
                              width: 70.rpx,
                              height: 44.rpx,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        tabBarIndex.value = 1;
                        controller.bewildermentController.text = '';
                        controller.initDragging();
                        controller.getDoubtList();
                        controller.getGold();
                      },
                    ),
                  ),
                ],
              ), state.tabBarIndex),
        ],
      ),
    );
  }

  ///周易
  Widget bookOfChanges() {
    return Container(
      margin: EdgeInsets.only(left: 12.rpx, right: 13.rpx, bottom: 20.rpx,top: 40.rpx),
      child: Column(
        children: [
          ObxValue((symbols) => ShakingContainer(
            yaoData: state.yaoData,
            symbols: symbols.value,
            trigram: state.trigram.value,
            callBack: (){
              controller.setYao();
            },
            allBack: (){
              controller.allYao();
            },
          ), state.symbols),
          ObxValue((hexagram) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.rpx,
                crossAxisSpacing: 6.rpx,
                mainAxisExtent: 40.rpx,
              ),
              itemCount: hexagram.length,
              padding: EdgeInsets.only(top: 16.rpx),
              itemBuilder: (_, i) {
                var item = hexagram[i];
                return Container(
                  width: 170.rpx,
                  padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                  decoration: BoxDecoration(
                      color: AppColor.gray13,
                    border: Border.all(width: 1.rpx,color: AppColor.brown37),
                      borderRadius: BorderRadius.all(Radius.circular(20.rpx)),
                  ),
                  child: Row(
                    children: [
                      Text('${item['name']}:', style: TextStyle(
                          fontSize: 14.rpx, color: AppColor.brown36),),
                      SizedBox(width: 16.rpx,),
                      Text(' ${item['value']}', style: TextStyle(
                          fontSize: 14.rpx, color: AppColor.brown36,)),
                    ],
                  ),
                );
              },
            );
          }, state.hexagram),
        ],
      ),
    );
  }

  ///塔罗牌
  Widget tarot() {
    return Container(
      padding: EdgeInsets.only(bottom: 30.rpx),
      child: Column(
        children: [
          Visibility(
            visible: state.rewashing.value,
            replacement: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 20.rpx),
              child: AppImage.asset(
                "assets/images/disambiguation/chuck.png",
                height: 110.rpx,
                width: 150.rpx,
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(state.randomTarot.length, (index) {
                  return AppImage.network(
                    "${state.randomTarot[index]['url']}${state.randomTarot[index]['name']}.png",
                    width: 82.rpx,
                    height: 110.rpx,
                    borderRadius: BorderRadius.circular(8.0),
                  );
                }),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.initDragging();
              controller.getTarot();
            },
            child: Container(
              width: 140.rpx,
              height: 40.rpx,
              decoration: BoxDecoration(
                image: AppDecorations.backgroundImage(
                    'assets/images/disambiguation/symbols.png'
                ),
              ),
              alignment: Alignment.center,
              child: Text(state.rewashing.value ? "重新抽牌" : "立即抽牌", style: TextStyle(fontSize: 18.rpx,
                  color: const Color(0xffEEC88A),
                  fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }

  ///困惑
  Widget bewilderment() {
    return Container(
      margin: EdgeInsets.only(left: 12.rpx, right: 8.rpx, bottom: 20.rpx),
      padding: EdgeInsets.all(12.rpx),
      decoration: BoxDecoration(
          color: AppColor.brown2,
          borderRadius: BorderRadius.circular(8.rpx)
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8.rpx),
            decoration: BoxDecoration(
              color: AppColor.brown14,
              borderRadius: BorderRadius.circular(8.rpx),
            ),
            height: 90.rpx,
            child: TextField(
              controller: controller.bewildermentController,
              maxLength: 100,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.brown14,
                hintText: "说出困惑，修行之路不迷茫",
                contentPadding: EdgeInsets.only(top: 12.rpx,left: 12.rpx,right: 12.rpx),
                counterStyle: TextStyle(
                    fontSize: 14.rpx,
                    color: AppColor.brown36
                ),
                hintStyle: TextStyle(
                  fontSize: 14.rpx,
                  color: AppColor.brown36
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.rpx),
                    topRight: Radius.circular(8.rpx),
                  ),
                ),
              ),
            ),
          ),
          ExamineButton(
            costGold: state.costGold != 0 ? state.costGold : 0,
            callBack: () {
              controller.switchType();
            },
          ),
          Visibility(
            visible: state.allBewilderment.isNotEmpty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage.asset(
                  "assets/images/disambiguation/rhombus.png",
                  width: 12.rpx,
                  height: 12.rpx,
                ),
                Text(" 大家的困惑 ", style: TextStyle(
                    fontSize: 16.rpx,
                    color: AppColor.brown36),),
                AppImage.asset(
                  "assets/images/disambiguation/rhombus.png",
                  width: 12.rpx,
                  height: 12.rpx,
                )
              ],
            ),
          ),
          Visibility(
            visible: state.allBewilderment.isNotEmpty,
            child: Container(
              margin: EdgeInsets.only(top: 18.rpx),
              width: 270.rpx,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AppAssetImage(
                    'assets/images/disambiguation/atAloss.png',
                  ),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Wrap(
                spacing: 16.rpx,
                runSpacing: 10.rpx,
                children: List.generate(state.allBewilderment.length, (i) {
                  var item = state.allBewilderment[i];
                  return Visibility(
                    visible: item['doubt'] != '',
                    child: GestureDetector(
                      onTap: (){
                        controller.getLogDetail(id: item['id']);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.brown35,
                          gradient: const LinearGradient(
                            colors: [AppColor.brown35, AppColor.brown2],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(30.rpx),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.gray11.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 12.rpx, horizontal: 16.rpx),
                        child: Text(item['doubt'], style: AppTextStyle.fs14m.copyWith(color: AppColor.gray5),),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

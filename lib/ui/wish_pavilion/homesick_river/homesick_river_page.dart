import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../common/network/api/model/talk_model.dart';
import 'homesick_river_controller.dart';
import 'widget/drifting_container.dart';
import 'widget/watercourse.dart';

///思亲河
class HomesickRiverPage extends StatelessWidget {
  HomesickRiverPage({Key? key}) : super(key: key);

  final controller = Get.put(HomesickRiverController());
  final state = Get.find<HomesickRiverController>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: AppBackButton.light(),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: GetBuilder<HomesickRiverController>(
        builder: (_){
          return Stack(
            children: [
              AppImage.asset(
                width: Get.width,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                "assets/images/wish_pavilion/homesick/background.jpg",
              ),
              AppImage.svga(
                'assets/svga/ripple.svga',
                width: Get.width,
                height: Get.height,
              ),
              AppImage.asset(
                width: Get.width,
                height: Get.height,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                "assets/images/wish_pavilion/homesick/river.png",
              ),
              drifting(),
              skyWidget(),
              buildHomesick()
            ],
          );
        },
      ),
    );
  }


  //天灯
  Widget skyWidget(){
    return Obx(() => Stack(
      children: [
        ...List.generate(state.skyData.length, (i){
          RecordLightModel item = state.skyData[i]!;
          return LanternWidget(
            currentIndex: i,
            child: GestureDetector(
              onTap: (){
                controller.getRecordById(item: item);
              },
              child: Column(
                children: [
                  Visibility(
                    visible: item.uid == SS.login.userId,
                    child: AppImage.asset(
                      "assets/images/wish_pavilion/homesick/self.png",
                      width: 22.rpx,
                      height: 18.rpx,
                    ),
                  ),
                  AppImage.network(
                    "${item.image}",
                    width: 60.rpx,
                    height: 90.rpx,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ));
  }

  //漂流
   Widget drifting(){
    return Obx(() => Stack(
      children: [
        ...List.generate(state.riverData.length, (i){
          return i < 5 ?
          waterLantern(
            left: state.points[i].dx,
            bottom: state.points[i].dy,
            index: i,
          ) :
          waterLantern(
            left:state.defaultPoints.dx,
            bottom: state.defaultPoints.dy,
            index: i,
          );
        }),
      ],
    ));
   }

  ///河灯
  Widget waterLantern({required double bottom,required double left,required int index}){
    return WatercourseWidget(
      index: index,
        startPoint: Offset(left, bottom),
        child: Stack(
          children: [
            Visibility(
              visible: state.riverData[index]!.uid == SS.login.userId,
              child: Positioned(
                bottom: controller.selfBottom(index),
                right: 4.rpx,
                child: AppImage.asset('assets/images/wish_pavilion/homesick/river_self.png',
                  width: controller.selfSize(index),
                  height: (index < 4 && index != 0) ? 18.rpx : (index == 4 ? 14.rpx : 22.rpx),
                ),),
            ),
            GestureDetector(
              onTap: (){
                controller.getRecordById(item: state.riverData[index]!);
              },
              child: AppImage.network(state.riverData[index]!.image ?? '',
                width: index < 5 ? controller.sizeWidget(index) : 90.rpx,
                height: index < 5 ? controller.sizeWidget(index):90.rpx,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      );
  }

  ///思亲类型
  Widget buildHomesick(){
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 30.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(state.homesickType.length, (index) {
          return GestureDetector(
            onTap: (){
              controller.onTapNext(index);
            },
            child: Container(
              width: 100.rpx,
              height: 43.rpx,
              decoration: BoxDecoration(
                image: AppDecorations.backgroundImage("assets/images/wish_pavilion/homesick/bottom_back.png"),
              ),
              alignment: Alignment.center,
              child: Text(state.homesickType[index],style: TextStyle(fontSize: 16.rpx,color: const Color(0xff8D310F),fontWeight: FontWeight.bold),),
            ),
          );
        }),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/fortune_square/fortune_square_view.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/system_ui.dart';

import 'dating_hall/dating_hall_view.dart';
import 'nearby_hall/nearby_hall_view.dart';
import 'plaza_controller.dart';

///广场
class PlazaPage extends StatefulWidget {
  const PlazaPage({super.key});

  @override
  State<PlazaPage> createState() => _PlazaPageState();
}

class _PlazaPageState extends State<PlazaPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(PlazaController());
  final state = Get.find<PlazaController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SystemUI.dark(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AppAssetImage("assets/images/plaza/recommend_back.png"),
              fit: BoxFit.fill
          ),
        ),
        child: Column(
          children: [
            appBar(),
            Expanded(
              child: TabBarView(
                  controller: controller.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    DatingHallView(),
                    NearbyHallView(),
                    FortuneSquareView(),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
  Widget appBar() {
    return GetBuilder<PlazaController>(
      id: "appBar",
      builder: (_) {
        return Container(
          height: Get.mediaQuery.padding.top+44.rpx,
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top,left: 16.rpx),
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: controller.tabController,
            labelStyle: AppTextStyle.fs18b,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            unselectedLabelStyle: AppTextStyle.fs16m,
            isScrollable: true,
            indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.rpx)
            ),
            indicatorPadding: EdgeInsets.only(top: 22.rpx,right: 38.rpx,left: 4.rpx),
            labelPadding: EdgeInsets.only(bottom: 5.rpx),
            tabs: List.generate(state.tabBarList.length, (index) {
              return  GestureDetector(
                onTap: (){
                  controller.tabController.index = index;
                  controller.update(['appBar']);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  margin: EdgeInsets.only(right: 32.rpx),
                  child: Text(
                    state.tabBarList[index]['name'],
                    style: controller.tabController.index == index ? AppTextStyle.fs18b.copyWith(height: 1,color: Colors.white):
                    AppTextStyle.fs16m.copyWith(height: 1,color: Colors.white.withOpacity(0.6)),
                  ),
                ),
              );
            }),
          ),
        );
      },);
  }
}

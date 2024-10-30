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
    return SystemUI.light(
      child: ObxValue((tabIndexRx) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AppAssetImage(state.tabBarList[tabIndexRx.value]['img']),
                fit: BoxFit.fill,alignment: Alignment.topCenter
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
        );
      },state.tabIndex),
    );
  }

  @override
  bool get wantKeepAlive => true;
  Widget appBar() {
    return Container(
      height: Get.mediaQuery.padding.top+44.rpx,
      padding: EdgeInsets.only(top: Get.mediaQuery.padding.top,left: 16.rpx),
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: controller.tabController,
        labelStyle: AppTextStyle.fs24,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        unselectedLabelStyle: AppTextStyle.fs16,
        isScrollable: true,
        indicator: const BoxDecoration(),
        indicatorPadding: EdgeInsets.only(top: 24.rpx,right: 38.rpx,left: 4.rpx),
        labelPadding: EdgeInsets.only(bottom: 0.rpx),
        onTap: (val){
          state.tabIndex.value = val;
        },
        tabs: List.generate(state.tabBarList.length, (index) {
          return Container(
            margin: EdgeInsets.only(right: 32.rpx),
            child: Text(state.tabBarList[index]['name']
            ),
          );
        }),
      ),
    );
  }
}

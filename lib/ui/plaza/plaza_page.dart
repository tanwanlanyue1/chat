import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/fortune_square/fortune_square_view.dart';
import 'package:guanjia/widgets/app_image.dart';

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
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: Column(
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
  }

  @override
  bool get wantKeepAlive => true;

  Widget appBar() {
    return GetBuilder<PlazaController>(
      id: "appBar",
      builder: (_) {
        return Container(
          height: Get.mediaQuery.padding.top+44.rpx,
          color: Colors.white,
          padding: EdgeInsets.only(top: Get.mediaQuery.padding.top,left: 16.rpx,bottom: 10.rpx),
          child: Row(
              children: List.generate(state.tabBarList.length, (index) {
                return GestureDetector(
                  onTap: (){
                    controller.tabController.index = index;
                    controller.update(['appBar']);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [controller.tabController.index == index ? AppColor.gradientBegin: AppColor.gray9,
                                controller.tabController.index == index ? AppColor.gradientEnd : AppColor.gray9],
                            ).createShader(Offset.zero & bounds.size);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Container(
                            margin: EdgeInsets.only(right: 32.rpx),
                            child: Text(
                              state.tabBarList[index]['name'],
                              style: controller.tabController.index == index ? (index == 2 ? AppTextStyle.fs24b.copyWith(height: 1) : AppTextStyle.fs18b.copyWith(height: 1)):AppTextStyle.fs16b.copyWith(height: 1),
                            ),
                          )
                      ),
                      Container(
                        width: 24.rpx,
                        height: 3.rpx,
                        margin: EdgeInsets.only(right: 36.rpx,top: 4.rpx),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.rpx),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: (controller.tabController.index == index && index != 2)?
                              [AppColor.gradientBegin, AppColor.gradientEnd]:
                              [Colors.transparent,Colors.transparent],
                            )
                        ),
                      )
                    ],
                  ),
                );
              },)),
        );
      },);
  }
}

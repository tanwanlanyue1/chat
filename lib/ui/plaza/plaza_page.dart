import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/fortune_square/fortune_square_view.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'dating_hall/dating_hall_view.dart';
import 'plaza_controller.dart';
///广场
class PlazaPage extends StatefulWidget {
  const PlazaPage({super.key});

  @override
  State<PlazaPage> createState() => _PlazaPageState();
}

class _PlazaPageState extends State<PlazaPage> with AutomaticKeepAliveClientMixin {

  final controller = Get.put(PlazaController());
  final state = Get.find<PlazaController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: List.generate(state.tabBarList.length, (index) {
            return GestureDetector(
              onTap: (){
                controller.tabController.index = index;
              },
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [controller.tabController.index == index ? AppColor.gradientBegin: AppColor.gray30,controller.tabController.index == index ? AppColor.gradientEnd : AppColor.gray30],
                    ).createShader(Offset.zero & bounds.size);
                  },
                  blendMode: BlendMode.srcATop,
                  child: Container(
                    margin: EdgeInsets.only(right: 36.rpx),
                    child: Text(
                      state.tabBarList[index]['name'],
                      style:controller.tabController.index == index ? AppTextStyle.fs18b:AppTextStyle.fs16m,
                    ),
                  )
              ),
            );
          },
        )),
      ),
      body: TabBarView(
          controller: controller.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            DatingHallView(),
            Column(
              children: [
                Expanded(
                  child: FortuneSquareView(),
                )
              ],
            ),
            Container(
              child: const Text("12313"),
            ),
          ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}
//FortuneSquareView
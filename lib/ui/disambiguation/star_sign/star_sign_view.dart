import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_fortune/star_fortune_view.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_inquire/star_inquire_view.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_pairing/star_pairing_view.dart';
import 'package:guanjia/ui/disambiguation/widgets/disambiguation_form_title.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

import 'star_sign_controller.dart';

///星座
class StarSignView extends StatelessWidget {
  StarSignView({super.key});

  late final controller = Get.put(StarSignController());
  late final state = Get
      .find<StarSignController>()
      .state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StarSignController>(
      init: StarSignController(),
      builder: (_){
        return Column(
          children: [
            DisambiguationFromTitle(
                title: "我的星座",
                carousel: state.carousel
            ),
            buildTabBar(),
            Expanded(
              child: buildBode(),
            )
          ],
        );
      },
    );
  }

  ///tabBar
  Widget buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.rpx),
          topRight: Radius.circular(16.rpx),
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12.rpx),
      child: ObxValue((titleIndex) =>
          Row(
            children: List.generate(state.titleTab.length, (i) =>
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.rpx,
                      decoration: BoxDecoration(
                        color: titleIndex.value == i
                            ? AppColor.brown12
                            : AppColor.brown38,
                        gradient: LinearGradient(
                          colors: titleIndex.value == i ?
                          [AppColor.brown40, AppColor.brown41] :
                          [AppColor.brown38, AppColor.brown38],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(i == 0 ? 16.rpx : 0),
                          topRight: Radius.circular(i == 2 ? 16.rpx : 0),
                        ),
                      ),//titleIndex.value == i
                      child: Text("${state.titleTab[i]['name']}",
                        style: titleIndex.value == i ?
                        AppTextStyle.fs16b.copyWith(color: AppColor.gray5):
                        AppTextStyle.fs16m.copyWith(color: AppColor.gray30),
                      ),
                    ),
                    onTap: () {
                      titleIndex.value = i;
                    },
                  ),
                )),
          ), state.titleIndex),
    );
  }

  ///星座类型内容
  Widget buildBode() {
    Widget child = Container();
    return ObxValue((dataRx) {
      switch (dataRx.value) {
        case 0:
          child = StarFortuneView();
          break;
        case 1:
          child = StarInquireView();
          break;
        case 2:
          child = StarPairingView();
          break;
      }
      return Container(
        decoration: BoxDecoration(
          color: AppColor.brown2,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.rpx),
            bottomRight: Radius.circular(8.rpx),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.rpx),
        margin: EdgeInsets.only(left: 12.rpx, right: 12.rpx,bottom: 20.rpx),
        child: child,
      );
    }, state.titleIndex);
  }

}

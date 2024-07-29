import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/network/api/model/open/app_config_model.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/disambiguation/default/default_view.dart';
import 'package:guanjia/ui/disambiguation/disambiguation_state.dart';
import 'package:guanjia/ui/disambiguation/divination/divination_view.dart';
import 'package:guanjia/ui/disambiguation/fortune/fortune_view.dart';
import 'package:guanjia/ui/disambiguation/oneiromancy/oneiromancy_view.dart';
import 'package:guanjia/ui/disambiguation/star_sign/star_sign_view.dart';
import 'package:guanjia/ui/disambiguation/take_name/take_name_view.dart';
import 'package:guanjia/ui/disambiguation/widgets/tab_decoration.dart';
import 'package:guanjia/ui/home/widget/home_drawer_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'disambiguation_controller.dart';

///解疑
class DisambiguationPage extends StatefulWidget {
  const DisambiguationPage({super.key});

  @override
  State<DisambiguationPage> createState() => _DisambiguationPageState();
}

class _DisambiguationPageState extends State<DisambiguationPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(DisambiguationController());
  final state = Get.find<DisambiguationController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SystemUI.light(
      child: Stack(
        children: [
          Obx(() {
            return state.appHome().isNotEmpty ?
            FadeInImage(
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 1),
              fadeOutDuration: const Duration(milliseconds: 1),
              placeholder: NetworkImage(state.appHome[state.divinationIndex.value].background ?? ''),
              image: NetworkImage(state.appHome[state.divinationIndex.value].background ?? ''),
              width: double.infinity,
              height: 200.rpx,
            ):
            FadeInImage(
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 1),
              fadeOutDuration: const Duration(milliseconds: 1),
              placeholder: AppAssetImage('assets/images/disambiguation/head_background.png'),
              image: AppAssetImage('assets/images/disambiguation/head_background.png'),
              width: double.infinity,
              height: 200.rpx,
            );
          }),
          buildHead(),
        ],
      ),
    );
  }

  ///头部
  Widget buildHead() {
    return Container(
      padding: EdgeInsets.only(top: 44.rpx),
      child: Column(
        children: [
          Container(
            height: 44.rpx,
            padding: EdgeInsets.symmetric(horizontal: 16.rpx),
            child: Row(
              children: [
                Text(
                  '见闻佛法,心诚则灵',
                  style: AppTextStyle.fs16b.copyWith(color: Colors.white),
                ),
                const Spacer(),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12.rpx),
                    child: AppImage.asset(
                      "assets/images/disambiguation/signIn.png",
                      width: 24.rpx,
                      height: 24.rpx,
                    ),
                  ),
                  onTap: () {
                    Get.toNamed(AppRoutes.minePurchase);
                  },
                ),
                GestureDetector(
                  onTap: HomeDrawerController.open,
                  child: AppImage.asset(
                    "assets/images/home/conversation.png",
                    width: 24.rpx,
                    height: 24.rpx,
                  ),
                ),
              ],
            ),
          ),
          buildDisambiguationType(),
          Expanded(
            child: buildTypeBody(),
          )
        ],
      ),
    );
  }

  ///解谜类型
  Widget buildDisambiguationType() {
    return Obx(() {
      final selectedIndex = state.divinationIndex.value;
      return state.appHome().isNotEmpty ?
      Container(
        margin: EdgeInsets.only(top: 4.rpx),
        height: 80.rpx,
        child: TabBar(
          controller: controller.tabController,
          isScrollable: false,
          labelPadding: EdgeInsets.only(bottom: 8.rpx),
          onTap: (val) {
            state.prevIndex = state.divinationIndex.value;
            state.divinationIndex.value = val;
          },
          indicator: TabDecoration(state.appHome().length),
          tabs: List.generate(state.appHome().length, (i) {
            // DisambiguationType item = state.disambiguationItem[i];
            Home item = state.appHome()[i];
            final isSelected = selectedIndex == i;
            var size = Size(58.rpx, 58.rpx);
            var sizeSmall = Size(50.rpx, 50.rpx);
            return SizedBox.fromSize(
              size: size,
              child: TweenAnimationBuilder<double>(
                key: Key('$isSelected'),
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 300),
                builder: (_, value, child) {
                  final sizes = [
                    Size.lerp(size, sizeSmall, value) ?? sizeSmall,
                    Size.lerp(sizeSmall, size, value) ?? size,
                  ];
                  return Center(
                    child: Image.network(
                      isSelected ? (item.selectIcon ?? '') : (item.icon ?? ''),
                      width: isSelected ? sizes.last.width : sizes.first.width,
                      height:
                          isSelected ? sizes.last.height : sizes.first.height,
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ):
      Container(
        height: 84.rpx,
      );
    });
  }

  ///内容
  Widget buildTypeBody() {
    return Obx(() {
      Widget child = DivinationView();
      // Widget child = DefaultView();
      switch (
      state.appHome().isNotEmpty ? (state.appHome[state.divinationIndex.value].id ?? 0) : 0) {
        case 1:
          child = DivinationView();
          break;
        case 2:
          child = TakeNameView();
          break;
        case 3:
          child = StarSignView();
          break;
        case 4:
          child = FortuneView();
          break;
        case 5:
          child = OneiromancyView();
          break;
      }
      return Container(
        margin: EdgeInsets.only(top: 8.rpx),
        decoration: BoxDecoration(
          color: const Color(0xffF5F1E9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.rpx),
            topRight: Radius.circular(20.rpx),
          ),
        ),
        child: child,
      );
    },);
  }

  @override
  bool get wantKeepAlive => true;
}

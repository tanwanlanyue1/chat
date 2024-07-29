import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/system_ui.dart';

import '../../widgets/app_image.dart';
import 'wish_pavilion_controller.dart';

///心愿阁
class WishPavilionPage extends StatefulWidget {
  const WishPavilionPage({super.key});

  @override
  State<WishPavilionPage> createState() => _WishPavilionPageState();
}

class _WishPavilionPageState extends State<WishPavilionPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(WishPavilionController());
  final state = Get.find<WishPavilionController>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> generatePositionedWidgets() {
      return List.generate(state.items.length, (index) {
        var item = state.items[index];
        return [
          Positioned(
            top: item.top?.rpx,
            bottom: item.bottom?.rpx,
            left: item.left?.rpx,
            right: item.right?.rpx,
            child: GestureDetector(
              onTap: item.titleIcon.isNotEmpty
                  ? () => controller.onTapNext(item.type)
                  : null,
              child: AppImage.asset(
                item.icon,
                width: item.width?.rpx,
                height: item.height?.rpx,
              ),
            ),
          ),
          if (item.titleIcon.isNotEmpty)
            Positioned(
              top: item.titleTop?.rpx,
              bottom: item.titleBottom?.rpx,
              left: item.titleLeft?.rpx,
              right: item.titleRight?.rpx,
              child: IgnorePointer(
                ignoring: true,
                child: AppImage.asset(
                  item.titleIcon,
                  width: item.titleWidth?.rpx,
                  height: item.titleHeight?.rpx,
                ),
              ),
            ),
        ];
      }).expand((item) => item).toList();
    }

    //375x729

    return SystemUI.dark(
      child: LayoutBuilder(
        builder: (_, constraints) {
          //如果可用宽高比例超过设计图的比例，无需滚动
          const minScale = 729 / 375.0;
          final scale = constraints.maxHeight / constraints.maxWidth;

          return SingleChildScrollView(
            physics: scale > minScale
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            child: Stack(
              children: [
                AppImage.asset(
                  "assets/images/wish_pavilion/bg.png",
                ),
                ...generatePositionedWidgets(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

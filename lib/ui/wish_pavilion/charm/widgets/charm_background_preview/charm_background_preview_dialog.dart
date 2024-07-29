import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'charm_background_preview_controller.dart';

class CharmBackgroundPreviewDialog extends StatelessWidget {
  final String url;

  const CharmBackgroundPreviewDialog(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CharmBackgroundPreviewController>(
      init: CharmBackgroundPreviewController(url),
      builder: (controller) {
        return GestureDetector(
          onTap: Get.back,
          child: Visibility(
              visible: controller.isLoad,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  AppImage.network(
                    url,
                    resizeImage: false,
                    fit: BoxFit.cover,
                    align: Alignment.bottomCenter,
                  ),
                  Positioned(
                    top: Get.mediaQuery.padding.top + 44.rpx,
                    child: AppImage.asset(
                      "assets/images/wish_pavilion/charm/time.png",
                      width: 171.rpx,
                      height: 107.rpx,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}

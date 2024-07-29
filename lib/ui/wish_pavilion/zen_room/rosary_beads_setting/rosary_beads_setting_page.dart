import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/rosary_beads_product_model.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/rosary_beads_setting/rosary_beads_setting_state.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'rosary_beads_setting_controller.dart';

///背景设置
class RosaryBeadsSettingPage extends GetView<RosaryBeadsSettingController> {
  const RosaryBeadsSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('背景设置'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12.rpx),
            child: Text(
              '选择以下一张图片作为菩提念珠页面背景',
              style:
                  AppTextStyle.st.medium.size(14.rpx).textColor(AppColor.gray9),
            ),
          ),
          Expanded(
            child: PagedGridView(
              padding: EdgeInsets.symmetric(horizontal: 12.rpx),
              pagingController: controller.pagingController,
              builderDelegate:
                  DefaultPagedChildBuilderDelegate<RosaryBeadsProductModel>(
                      pagingController: controller.pagingController,
                      itemBuilder: (_, item, index) {
                        return buildItem(item);
                      }),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.rpx,
                crossAxisSpacing: 11.rpx,
                childAspectRatio: childAspectRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double get childAspectRatio => 17 / 23;

  Widget buildItem(RosaryBeadsProductModel item) {
    return GestureDetector(
      onTap: item.isNeedBuy ? null : () => controller.onTapItem(item),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: AppImage.network(
              width: Get.width / 2,
              height: Get.width / 2 / childAspectRatio,
              item.image,
              fit: BoxFit.cover,
            ),
          ),
          if (item.id == controller.currentBackgroundId) buildUsedFlag(),
          if (item.id != controller.currentBackgroundId && item.isNeedBuy) buildBuyButton(item),
        ],
      ),
    );
  }

  Widget buildBuyButton(RosaryBeadsProductModel item) {
    return GestureDetector(
      onTap: (){
        controller.onTapItem(item);
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: Colors.white,
        radius: Radius.circular(4.rpx),
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.rpx),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.rpx, vertical: 8.rpx),
            color: const Color(0x70FFFFFF),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '购买',
                  style: AppTextStyle.st.size(14.rpx).textColor(AppColor.red1),
                ),
                Text(
                  '${item.price}境修币',
                  style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUsedFlag() {
    return DottedBorder(
      borderType: BorderType.RRect,
      color: Colors.white,
      radius: Radius.circular(4.rpx),
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.rpx),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.rpx, vertical: 8.rpx),
          color: const Color(0x70FFFFFF),
          child: Text(
            '当前使用',
            style: AppTextStyle.st.size(14.rpx).textColor(Colors.white),
          ),
        ),
      ),
    );
  }
}

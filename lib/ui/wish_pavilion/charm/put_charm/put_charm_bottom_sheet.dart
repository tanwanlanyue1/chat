import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/wish_pavilion/charm_record.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';

import 'put_charm_controller.dart';

class PutCharmBottomSheet extends StatelessWidget {
  PutCharmBottomSheet._({super.key});

  static Future<void> show() {
    return Get.bottomSheet<void>(
      PutCharmBottomSheet._(),
      isScrollControlled: true,
    );
  }

  final controller = Get.put(PutCharmController());
  final state = Get.find<PutCharmController>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PutCharmController>(
      assignId: true,
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: Get.back,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 90.rpx +
                    Get.mediaQuery.padding.top +
                    kBottomNavigationBarHeight,
                bottom: Get.mediaQuery.padding.bottom,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.rpx),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F3E8),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8.rpx),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 12.rpx, bottom: 16.rpx),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "我的灵符",
                          style: AppTextStyle.st.bold
                              .size(18.rpx)
                              .textColor(AppColor.gray5),
                        ),
                        GestureDetector(
                          onTap: Get.back,
                          child: Image.asset(
                            "assets/images/wish_pavilion/charm/close.png",
                            width: 24.rpx,
                            height: 24.rpx,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildContent(),
                  SizedBox(height: 26.rpx),
                  Expanded(
                    child: PagedGridView(
                      pagingController: controller.pagingController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 10 / 14,
                        mainAxisSpacing: 12.rpx,
                        crossAxisSpacing: 26.rpx,
                      ),
                      builderDelegate:
                          DefaultPagedChildBuilderDelegate<CharmRecord>(
                              pagingController: controller.pagingController,
                              itemBuilder: (_, item, index) {
                                final isSelect = index == state.selectIndex;

                                return GestureDetector(
                                  onTap: () => controller.onTapItem(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(4.rpx),
                                      border: isSelect
                                          ? Border.all(
                                              color: const Color(0xFFE4A547),
                                              width: 4,
                                            )
                                          : null,
                                    ),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return AppImage.network(
                                        item.currentStateImageUrl,
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight,
                                        fit: BoxFit.cover,
                                        align: Alignment.bottomCenter,
                                        borderRadius: isSelect
                                            ? null
                                            : BorderRadius.circular(4.rpx),
                                      );
                                    }),
                                  ),
                                );
                              }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent() {
    final item = state.charmRecord;
    if (item == null) return Container();

    final isLight = item.lightStatus == 1;
    final isBless = item.blessStatus == 1;

    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 21.rpx),
          width: 140.rpx,
          height: 210.rpx,
          child: AppImage.network(
            item.currentStateImageUrl,
            width: 140.rpx,
            height: 210.rpx,
            fit: BoxFit.cover,
            align: Alignment.bottomCenter,
            borderRadius: BorderRadius.circular(4.rpx),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style:
                    AppTextStyle.st.bold.size(16.rpx).textColor(AppColor.gray5),
                maxLines: 1,
              ),
              SizedBox(height: 8.rpx),
              Text(
                item.remark,
                style: AppTextStyle.st.size(14.rpx).textColor(AppColor.gray30),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16.rpx),
              Text.rich(
                maxLines: 1,
                TextSpan(
                  children: [
                    TextSpan(
                      text: "(${isLight ? "已" : "可"}开光)",
                      style: AppTextStyle.st.bold.size(14.rpx).textColor(
                          isLight ? AppColor.gray9 : const Color(0xFFE4A547)),
                    ),
                    TextSpan(
                      text: "(${isBless ? "已" : "可"}加持)",
                      style: AppTextStyle.st.bold.size(14.rpx).textColor(
                          isBless ? AppColor.gray9 : const Color(0xFFE4A547)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.rpx),
              Text(
                "开光加持后的灵符，心力相通，感应作用更强！",
                style: AppTextStyle.st.size(14.rpx).textColor(AppColor.gray9),
                maxLines: 2,
              ),
              SizedBox(height: 16.rpx),
              Center(
                child: GestureDetector(
                  onTap: controller.onTapPut,
                  child: Image.asset(
                    "assets/images/wish_pavilion/charm/put_button.png",
                    width: 120.rpx,
                    height: 40.rpx,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

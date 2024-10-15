import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/api.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/widgets/assign_agent_dialog/order_assign_agent_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

///客户缴纳保证金对话框
class OrderAssignAgentDialog extends GetView<OrderAssignAgentController> {
  const OrderAssignAgentDialog({super.key});

  static Future<bool?> show(int orderId) async {
    return Get.dialog(
      GetBuilder<OrderAssignAgentController>(
        init: OrderAssignAgentController(orderId),
        builder: (controller) {
          return const OrderAssignAgentDialog();
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 311.rpx,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: AppImage.asset(
                  'assets/images/common/close.png',
                  width: 24.rpx,
                  height: 24.rpx,
                ),
              ),
            ),
            Padding(
              padding: FEdgeInsets(horizontal: 16.rpx),
              child: Text(
                S.current.assignmentOrder,
                textAlign: TextAlign.center,
                style: AppTextStyle.fs18b.copyWith(color: AppColor.black3),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColor.scaffoldBackground,
                borderRadius: BorderRadius.all(Radius.circular(8.rpx)),
              ),
              margin: FEdgeInsets(horizontal: 16.rpx, top: 24.rpx),
              height: 288.rpx,
              child: PagedListView.separated(
                pagingController: controller.pagingController,
                builderDelegate: DefaultPagedChildBuilderDelegate<TeamUser>(
                  pagingController: controller.pagingController,
                  itemBuilder: (_, item, index) {
                    return _buildItem(item, index);
                  },
                ),
                separatorBuilder: (_, int index) {
                  return Divider(
                    height: 1,
                    color: AppColor.black92.withOpacity(0.1),
                    thickness: 1,
                    indent: 29.rpx,
                    endIndent: 16.rpx,
                  );
                },
              ),
            ),
            Padding(
              padding:
                  FEdgeInsets(horizontal: 16.rpx, top: 20.rpx, bottom: 24.rpx),
              child: CommonGradientButton(
                onTap: controller.onTapConfirm,
                height: 50.rpx,
                text: S.current.confirm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(TeamUser item, int index) {
    return Container(
      padding: FEdgeInsets(all: 16.rpx, left: 10.rpx),
      child: Row(
        children: [
          AppImage.network(
            item.avatar ?? "",
            width: 40.rpx,
            height: 40.rpx,
            shape: BoxShape.circle,
          ),
          SizedBox(width: 16.rpx),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nickname ?? '',
                  style: AppTextStyle.st.semiBold
                      .size(14.rpx)
                      .textColor(AppColor.black3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.rpx),
                Row(
                  children: [
                    if (item.gender != 0)
                      Padding(
                        padding: EdgeInsets.only(right: 8.rpx),
                        child: AppImage.asset(
                          item.gender == 2
                              ? "assets/images/common/female.png"
                              : "assets/images/common/male.png",
                          size: 16.rpx,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        "${item.age ?? ""}",
                        style: AppTextStyle.st.medium
                            .size(14.rpx)
                            .textColor(AppColor.black3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(() {
            return GestureDetector(
              onTap: () => controller.onTapSelect(index),
              child: Container(
                width: 70.rpx,
                height: 28.rpx,
                margin: EdgeInsets.only(left: 8.rpx),
                decoration: BoxDecoration(
                  color: controller.selectIndex.value == index
                      ? item.gender == 2
                          ? AppColor.textPurple
                          : AppColor.textBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.rpx),
                  ),
                  border: controller.selectIndex.value == index
                      ? null
                      : Border.all(color: AppColor.black92),
                ),
                alignment: Alignment.center,
                child: Text(
                  controller.selectIndex.value == index ? S.current.sendOrdersToTa : S.current.choose,
                  style: AppTextStyle.st.medium.size(12.rpx).textColor(
                      controller.selectIndex.value == index
                          ? Colors.white
                          : AppColor.black92),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/network/api/model/user/purse_log_list.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/wallet/wallet_controller.dart';
import 'package:guanjia/ui/wallet/widgets/record/wallet_record_controller.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/common_gradient_button.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WalletRecordWidget extends GetView<WalletRecordController> {
  const WalletRecordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletRecordController>(
      init: WalletRecordController(),
      builder: (controller) {
        return PagedListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.rpx, vertical: 24.rpx),
          pagingController: controller.pagingController,
          builderDelegate: DefaultPagedChildBuilderDelegate(
            pagingController: controller.pagingController,
            itemBuilder: (_, item, index) {
              if (item is PurseLogList) {
                return _buildItem(item);
              }
              return const SizedBox();
            },
          ),
          separatorBuilder: (_, __) {
            return SizedBox(height: 24.rpx);
          },
        );
      },
    );
  }

  Widget _buildItem(PurseLogList item) {
    final opt = item.optType == 1 ? "+" : "-";

    return SizedBox(
      height: 80.rpx,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CommonUtils.timestamp(item.createTime, unit: "dd/MM/yyyy"),
            style: AppTextStyle.st.size(12.rpx).textColor(AppColor.black999),
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 36.rpx,
                  height: 36.rpx,
                  margin: EdgeInsets.only(right: 12.rpx),
                  child: AppImage.network(
                    item.icon,
                    length: 36.rpx,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.typeName,
                    style: AppTextStyle.st
                        .size(14.rpx)
                        .textColor(AppColor.black999),
                  ),
                ),
                Text(
                  "$opt￥${item.amount}",
                  style: AppTextStyle.st.medium
                      .size(18.rpx)
                      .textColor(AppColor.blackBlue),
                ),
              ],
            ),
          ),
          Divider(
            color: AppColor.black999.withOpacity(0.1),
            height: 1,
          ),
        ],
      ),
    );
  }
}

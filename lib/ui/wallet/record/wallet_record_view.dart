import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/paging/default_paged_child_builder_delegate.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../common/network/api/model/user/talk_user.dart';
import '../../../common/utils/common_utils.dart';
import 'wallet_record_controller.dart';

///钱包记录
class WalletRecordView extends StatefulWidget {
  const WalletRecordView({super.key});

  @override
  State<WalletRecordView> createState() => _WalletRecordViewState();
}

class _WalletRecordViewState extends State<WalletRecordView> with AutomaticKeepAliveClientMixin {

  final controller = Get.put(WalletRecordController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        SmartRefresher(
          controller: controller.pagingController.refreshController,
          onRefresh: controller.pagingController.onRefresh,
          child: PagedListView.separated(
            padding:
            EdgeInsets.symmetric(horizontal: 16.rpx, vertical: 24.rpx),
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
              return Divider(
                height: 32.rpx,
              );
            },
          ),
        ),
        Positioned(
          top: 16.rpx,
          right: 16.rpx,
          child: Button.outlineStadium(
            onPressed: controller.onTapFilter,
            height: 24.rpx,
            backgroundColor: Colors.white,
            borderColor: AppColor.black999.withOpacity(0.1),
            padding: FEdgeInsets(left: 8.rpx, right: 4.rpx),
            child: Row(
              children: [
                Obx(() {
                  return Text(
                    controller.recordTypeRx()?.label ?? '筛选',
                    style: AppTextStyle.st
                        .size(12.rpx)
                        .textColor(AppColor.black3),
                  );
                }),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20.rpx,
                  color: AppColor.black3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(PurseLogList item) {
    final opt = item.optType == 1 ? "+" : "-";

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.createTime.dateTime.formatYMDHHmm2,
          style: AppTextStyle.fs12m.copyWith(
            color: AppColor.black999,
            height: 1.0,
          ),
        ),
        Padding(
          padding: FEdgeInsets(top: 16.rpx),
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
                  style: AppTextStyle.fs14m.copyWith(
                    color: AppColor.black999,
                    height: 1.0,
                  ),
                ),
              ),
              Text(
                "$opt${item.amount.toCurrencyString()}",
                style: AppTextStyle.st.bold
                    .size(18.rpx)
                    .textColor(AppColor.black3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

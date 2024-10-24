import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/common_utils.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/model/order_list_item.dart';
import 'package:guanjia/ui/order/order_list/order_list_page.dart';
import 'package:guanjia/ui/order/widgets/order_operation_buttons.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

class OrderListTile extends StatefulWidget {
  OrderListTile({
    super.key,
    required this.onTap,
    required this.widget,
    required this.item,
    required this.index,
  });

  final VoidCallback? onTap;
  final OrderListPage widget;
  final OrderListItem item;
  final int index;

  Timer? timer;

  @override
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  @override
  void initState() {
    if (widget.item.countDown > 0) {
      if (mounted) {
        widget.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          widget.item.countDown = widget.item.countDown - 1;
          setState(() {});
        });
      }
    } else {
      widget.timer?.cancel();
    }

    super.initState();
  }

  OrderListItem get item => widget.item;

  @override
  Widget build(BuildContext context) {
    Widget operationWidget =
        OrderOperationButtons(type: widget.widget.type, item: widget.item);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 186.rpx,
        padding: EdgeInsets.all(16.rpx).copyWith(bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.rpx),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildStateText(),
                if (item.countDown > 0)
                  Flexible(
                    child: Text(
                      "${S.current.residualWait} ${CommonUtils.convertCountdownToHMS(item.countDown, hasHours: false)}",
                      style: AppTextStyle.st
                          .size(12.rpx)
                          .textColor(AppColor.primaryBlue),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
            Divider(
              height: 25.rpx,
              thickness: 1.rpx,
              color: AppColor.scaffoldBackground,
            ),
            Row(
              children: [
                AppImage.network(
                  item.avatar,
                  length: 60.rpx,
                  shape: BoxShape.circle,
                ),
                SizedBox(width: 8.rpx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.number,
                        style: AppTextStyle.st
                            .size(14.rpx)
                            .textColor(AppColor.black6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.nick,
                        style: AppTextStyle.st
                            .size(14.rpx)
                            .textColor(AppColor.black6),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item.nickWithAgent != null)
                        Text(
                          item.nickWithAgent ?? "",
                          style: AppTextStyle.st
                              .size(14.rpx)
                              .textColor(AppColor.black6),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.rpx),
            Divider(
              height: 1.rpx,
              thickness: 1.rpx,
              color: AppColor.scaffoldBackground,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildDate(),
                  SizedBox(width: 8.rpx),
                  Flexible(
                    child: operationWidget,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDate(){
    return Row(
      children: [
        AppImage.asset(
          "assets/images/order/time.png",
          size: 16.rpx,
        ),
        SizedBox(width: 8.rpx),
        Text(
          item.time,
          style: AppTextStyle.st
              .size(12.rpx)
              .textColor(AppColor.black9),
        ),
        SizedBox(width: 8.rpx),
      ],
    );
  }

  Widget buildStateText(){
    return Container(
      padding: FEdgeInsets(horizontal: 12.rpx, vertical: 10.rpx),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            item.stateTextColor.withOpacity(0.1),
            item.stateTextColor.withOpacity(0),
          ],
        ),
      ),
      child: Text(
        item.stateText,
        style: AppTextStyle.st
            .size(14.rpx)
            .textHeight(1)
            .textColor(item.stateTextColor),
      ),
    );
  }

}

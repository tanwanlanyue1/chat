import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/extension/text_style_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/order/enum/order_enum.dart';
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

  @override
  State<OrderListTile> createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  @override
  void initState() {
    super.initState();
  }

  OrderListItem get item => widget.item;

  bool get hasContactButton{
    return item.operationType == OrderOperationType.connect;
  }

  @override
  Widget build(BuildContext context) {
    int index = (!item.nick.contains('：')) ? 0 : item.nick.indexOf('：');
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.rpx),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                buildStateText(),
                const Spacer(),
                if (item.countDown > 0)
                  Container(
                    // height: 20.rpx,
                    // alignment: Alignment.bottomCenter,
                    child: Text(
                      S.current.residualWait,
                      style: AppTextStyle.fs10.copyWith(
                        color: AppColor.blackBlue,
                        height: 1,
                      ),
                    ),
                  ),
                if (item.countDown > 0) buildCountdown(),
              ],
            ),
            Padding(
              padding: FEdgeInsets(all: 12.rpx),
              child: Row(
                children: [
                  UserAvatar.circle(
                    item.avatar,
                    size: 60.rpx,
                  ),
                  SizedBox(width: 8.rpx),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: S.current.orderReference,
                            style: AppTextStyle.st
                                .size(14.rpx)
                                .textColor(AppColor.black9),
                                children: [
                                      TextSpan(
                                      text: item.itemModel.number,
                                          style: TextStyle(color: AppColor.black6),
                                      )
                                ]
                          ),
                        ),
                        if((item.nickWithAgent ?? '').isEmpty) Spacing.h8,
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: index != 0 ? "${item.nick.substring(0,index)}：" : '',
                              style: AppTextStyle.st
                                  .size(14.rpx)
                                  .textColor(AppColor.black9),
                              children: [
                                TextSpan(
                                  text: item.nick.substring(index != 0 ? index+1 : 0),
                                  style: const TextStyle(color: AppColor.black6),
                                )
                              ]
                          ),
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
            ),
            if(!hasContactButton) Divider(
              indent: 8.rpx,
              endIndent: 8.rpx,
              height: 1,
            ),
            Padding(
              padding: FEdgeInsets(horizontal: 12.rpx, top: hasContactButton ? 0 : 12.rpx, bottom: 12.rpx),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: hasContactButton ? CrossAxisAlignment.end : CrossAxisAlignment.center,
                children: [
                  buildDate(),
                  OrderOperationButtons(
                    type: widget.widget.type, item: widget.item,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDate() {
    return Row(
      children: [
        AppImage.asset(
          "assets/images/order/time.png",
          size: 16.rpx,
        ),
        SizedBox(width: 4.rpx),
        Text(
          item.time,
          style: AppTextStyle.st.size(12.rpx).textColor(AppColor.black9),
        ),
      ],
    );
  }

  Widget buildCountdown() {
    if (item.countDown <= 0) {
      return Spacing.h(20);
    }

    buildItem(String text) {
      return Container(
        width: 24.rpx,
        height: 20.rpx,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.rpx),
          color: AppColor.red,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyle.fs12.copyWith(
            color: Colors.white,
            height: 1.0,
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      margin: FEdgeInsets(left: 4.rpx, top: 0.rpx, right: 12.rpx),
      child: CountdownBuilder(
        endTime: DateTime.now().add(Duration(seconds: item.countDown)),
        onFinish: () {
          if (mounted) {
            setState(() {
              item.countDown = 0;
            });
          }
        },
        builder: (duration, text) {
          final hours = duration.inHours.toString().padLeft(2, '0');
          final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (duration.inHours > 0) buildItem(hours),
              buildItem(minutes),
              buildItem(seconds),
            ]
                .separated(
                  Container(
                    width: 8.rpx,
                    height: 20.rpx,
                    alignment: Alignment.center,
                    padding: FEdgeInsets(bottom: 1.rpx),
                    child: Text(
                      ':',
                      style: AppTextStyle.fs12m.copyWith(
                        color: AppColor.red,
                        height: 1.0,
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          );
        },
      ),
    );
  }

  Widget buildStateText() {
    return Container(
      padding: FEdgeInsets(left: 12.rpx, right: 24.rpx),
      height: 36.rpx,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(4.rpx)),
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

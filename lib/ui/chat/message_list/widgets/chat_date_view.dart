import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/order/widgets/order_security_deposit_user_dialog.dart';
import 'package:guanjia/widgets/widgets.dart';

///约会状态View（显示在消息列表顶部）
class ChatDateView extends StatefulWidget {
  const ChatDateView({super.key});

  static double get height => 66.rpx;

  @override
  State<ChatDateView> createState() => _ChatDateViewState();
}

class _ChatDateViewState extends State<ChatDateView> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ChatDateView.height,
      color: AppColor.grayF7,
      padding: FEdgeInsets(horizontal: 16.rpx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '佳丽已接单，请您及时缴纳保证金服务费',
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.gray5,
              ),
            ),
          ),
          Padding(
            padding: FEdgeInsets(left: 16.rpx),
            child: CommonGradientButton(
              onTap: () => OrderSecurityDepositUserDialog.show(),
              height: 37.rpx,
              padding: FEdgeInsets(horizontal: 16.rpx),
              borderRadius: BorderRadius.zero,
              text: '立即缴纳',
              textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
            ),
          ),
          // Padding(
          //   padding: FEdgeInsets(left: 16.rpx),
          //   child: CommonGradientButton(
          //     onTap: () => OrderAcceptDialog.show(),
          //     height: 37.rpx,
          //     padding: FEdgeInsets(horizontal: 16.rpx),
          //     borderRadius: BorderRadius.zero,
          //     text: '立即接单',
          //     textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
          //   ),
          // ),
          // Padding(
          //   padding: FEdgeInsets(left: 16.rpx),
          //   child: CommonGradientButton(
          //     onTap: () => OrderCreateDialog.show(),
          //     height: 37.rpx,
          //     padding: FEdgeInsets(horizontal: 16.rpx),
          //     borderRadius: BorderRadius.zero,
          //     text: '立即缴纳',
          //     textStyle: AppTextStyle.fs14m.copyWith(color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}

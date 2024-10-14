import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';

///钱包地址弹出菜单按钮
class WalletAddressPopupMenuButton extends StatelessWidget {
  const WalletAddressPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46.rpx,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.rpx),
          color: AppColor.grayBackground),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'TATSrKqw1BozztMJCZns8izabtgm5Y9vzp',
              style: AppTextStyle.fs14m.copyWith(
                color: AppColor.black3,
              ),
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: AppColor.black9,
            size: 12.rpx,
          ),
        ],
      ),
    );
  }
}

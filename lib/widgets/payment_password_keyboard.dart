import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

///支付密码键盘对话框
class PaymentPasswordKeyboard extends StatefulWidget {
  String? titleStr;
  PaymentPasswordKeyboard._({super.key,this.titleStr});

  /// - return 返回支付密码
  static Future<String?> show({String? titleStr}) async {
    return Get.bottomSheet<String>(
      PaymentPasswordKeyboard._(titleStr: titleStr,),
      ignoreSafeArea: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.rpx)),
      ),
    );
  }

  @override
  State<PaymentPasswordKeyboard> createState() =>
      _PaymentPasswordKeyboardState();
}

class _PaymentPasswordKeyboardState extends State<PaymentPasswordKeyboard> {
  ///密码长度
  static const passwordLength = 6;
  static const backspace = 'backspace';
  final password = List.filled(passwordLength, '');
  final items = [
    ...List.generate(9, (index) => (index + 1).toString()),
    '',
    '0',
    backspace
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildTitleBar(),
        buildInput(),
        buildKeyboard(),
      ],
    );
  }

  Widget buildTitleBar() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          height: 56.rpx,
          margin: FEdgeInsets(horizontal: 16.rpx),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColor.gray5.withOpacity(0.2),
              ),
            ),
          ),
          child: Text(
            widget.titleStr ?? S.current.enterPaymentPassword,
            textAlign: TextAlign.center,
            style: AppTextStyle.fs18b.copyWith(color: AppColor.gray5),
          ),
        ),
        IconButton(
          onPressed: Get.back,
          icon: const Icon(
            Icons.close,
            color: AppColor.gray5,
          ),
        ),
      ],
    );
  }

  Widget buildInput() {
    final size = 48.rpx;
    return Container(
      height: size,
      margin: FEdgeInsets(top: 24.rpx, bottom: 34.rpx),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rpx),
        border: Border.all(color: AppColor.gray9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: password
            .map<Widget>((value) {
              return Container(
                alignment: const Alignment(0.0, 0.3),
                width: size,
                child: Text(
                  value.isNotEmpty ? '*' : '',
                  style: AppTextStyle.fs18b.copyWith(color: AppColor.gray5),
                ),
              );
            })
            .separated(
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColor.gray9.withOpacity(0.2),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget buildKeyboard() {
    return Container(
      padding: FEdgeInsets(bottom: 24.rpx + Get.mediaQuery.padding.bottom),
      color: const Color(0xFFD0D1D8),
      child: GridView.count(
        padding: FEdgeInsets(top: 4.rpx, horizontal: 4.rpx),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 120/46,
        mainAxisSpacing: 4.rpx,
        crossAxisSpacing: 4.rpx,
        children: items.mapIndexed(buildKeyboardItem).toList(),
      ),
    );
  }

  Widget buildKeyboardItem(int index, String item) {
    if (item.isEmpty) {
      return Spacing.blank;
    }
    if (item == backspace) {
      return Material(
        color: Colors.transparent,
        child: IconButton(
          onPressed: () {
            final index =
            password.lastIndexWhere((element) => element.isNotEmpty);
            if (index != -1) {
              setState(() {
                password[index] = '';
              });
            }
          },
          icon: const Icon(
            Icons.backspace_outlined,
            color: AppColor.gray5,
          ),
        ),
      );
    }

    return Material(
      borderRadius: BorderRadius.circular(4.rpx),
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(4.rpx),
        onTap: () {
          final index = password.indexWhere((element) => element.isEmpty);
          if(index != -1){
            setState(() {
              password[index] = item;
            });
          }
          if(password.every((element) => element.isNotEmpty)){
            Get.back(result: password.join());
          }
        },
        child: Center(
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: AppTextStyle.fs18b.copyWith(color: AppColor.gray5),
          ),
        ),
      ),
    );
  }
}

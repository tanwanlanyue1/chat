import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/get_extension.dart';
import 'package:guanjia/common/extension/iterable_extension.dart';
import 'package:guanjia/common/utils/decimal_text_input_formatter.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/edge_insets.dart';

///转账键盘
class TransferMoneyKeyboard extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<double>? onConfirm;
  final DecimalTextInputFormatter formatter;

  const TransferMoneyKeyboard({
    super.key,
    this.onChanged,
    this.onConfirm,
    required this.formatter,
  });

  @override
  State<TransferMoneyKeyboard> createState() => _TransferMoneyKeyboardState();
}

class _TransferMoneyKeyboardState extends State<TransferMoneyKeyboard> {
  static const backspace = 'backspace';
  static const dot = '.';
  static const confirm = 'confirm';
  final itemSize = Size(84.rpx, 44.rpx);
  final spacing = 8.rpx;
  var value = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.grayF7,
      padding: FEdgeInsets(all: spacing, bottom: spacing + Get.padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRow(['1', '2', '3', backspace]),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildRow(['4', '5', '6']),
                    buildRow(['7', '8', '9']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildItem('0', colSpan: 2),
                        buildItem(dot),
                      ],
                    ),
                  ]
                      .separated(SizedBox(height: spacing))
                      .toList(growable: false),
                ),
              ),
              buildSendButton(),
            ].separated(SizedBox(width: spacing)).toList(growable: false),
          ),
        ].separated(SizedBox(height: spacing)).toList(growable: false),
      ),
    );
  }

  Widget buildRow(List<String> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map(buildItem).toList(growable: false),
    );
  }

  Widget buildItem(String item, {int colSpan = 1}) {
    return SizedBox(
      width: itemSize.width * colSpan + (colSpan - 1) * spacing,
      height: itemSize.height,
      child: Material(
        borderRadius: BorderRadius.circular(4.rpx),
        color: Colors.white,
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.rpx),
          onTap: () {
            onTapItem(item);
          },
          child: Center(
            child: item == backspace
                ? Icon(
                    Icons.backspace,
                    color: AppColor.blackBlue,
                    size: 24.rpx,
                  )
                : Text(
                    item,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.fs20b
                        .copyWith(color: AppColor.blackBlue),
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildSendButton() {
    return SizedBox(
      width: itemSize.width,
      height: itemSize.height * 3 + 2 * spacing,
      child: Material(
        borderRadius: BorderRadius.circular(4.rpx),
        color: AppColor.primaryBlue,
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.rpx),
          onTap: () => onTapItem(confirm),
          child: Center(
            child: Text(
              '转账',
              textAlign: TextAlign.center,
              style: AppTextStyle.fs16b.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void onTapItem(String item) {
    switch (item) {
      case backspace:
        if (value.isNotEmpty) {
          value = value.substring(0, value.length - 1);
          widget.onChanged?.call(value);
        }
        return;
      case dot:
        if (value.contains(dot)) {
          return;
        }
        break;
      case confirm:
        var val = value;
        if (val.endsWith(dot)) {
          val = val.replaceFirst(dot, '');
        }
        widget.onConfirm?.call(double.tryParse(val) ?? 0);
        return;
      default:
        break;
    }

    //累加值
    final newValue = value + item;
    final editingValue = widget.formatter.formatEditUpdate(
      TextEditingValue(text: value),
      TextEditingValue(text: newValue),
    );
    if(editingValue.text != value){
      value = editingValue.text;
      widget.onChanged?.call(value);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/widgets/widgets.dart';

///契约单
class ContractView extends StatelessWidget {

  ///甲方
  final String partyA;

  ///乙方
  final String partyB;

  ///内容
  final String content;

  final String? dateLabel;

  ///时间
  final String date;

  const ContractView({
    super.key,
    required this.partyA,
    required this.partyB,
    required this.content,
    this.dateLabel,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: AppTextStyle.fs14m.copyWith(
        color: AppColor.gray5,
        height: 21 / 14,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //甲已双方
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRichText(S.current.partyA, partyA),
              buildRichText(S.current.partyB, partyB),
            ],
          ),
          Spacing.h24,
          Text(content),
          Container(
            alignment: Alignment.centerRight,
            padding: FEdgeInsets(top: 80.rpx),
            child: buildRichText(
              dateLabel ?? S.current.contractDate,
              date,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRichText(String text1, String text2) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: text1),
        TextSpan(
            text: text2,
            style: AppTextStyle.fs14m.copyWith(
              color: AppColor.gray30,
            )),
      ],
    ));
  }
}

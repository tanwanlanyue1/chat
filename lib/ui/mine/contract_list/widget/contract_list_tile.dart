import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/extension/date_time_extension.dart';
import 'package:guanjia/common/extension/int_extension.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/contract_detail/contract_detail_state.dart';
import 'package:guanjia/widgets/widgets.dart';

class ContractListTile extends StatelessWidget {
  final ContractModel model;
  final VoidCallback? onTap;

  const ContractListTile({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateTime = buildDateTime();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: FEdgeInsets(all: 24.rpx, left: 16.rpx),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildRichText("${S.current.brokerP}:", model.partyAName),
                  if(dateTime != null) dateTime,
                ],
              ),
            ),
            buildStatus(),
          ],
        ),
      ),
    );
  }

  Widget? buildDateTime() {
    var label = '';
    var text = '';
    switch (status) {
      case null:
      case ContractStatus.signing:
      case ContractStatus.reject:
      label = S.current.creationTime;
      text = model.createTime.dateTime.formatYMD2 ?? '';
      case ContractStatus.signed:
        label = S.current.effectiveTime;
        text = model.signingTime.dateTime.formatYMD2 ?? '';
        break;
      case ContractStatus.terminated:
        label = S.current.startStopTime;
        text = '${model.signingTime.dateTime.formatYMD2} - ${model.rescissionTime.dateTime.formatYMD2}';
        break;
    }

    return buildRichText(
      label,
      text,
    );
  }

  Widget buildRichText(String text1, String text2) {
    return Text.rich(TextSpan(
      style: AppTextStyle.fs14m.copyWith(
        color: AppColor.black666,
      ),
      children: [
        TextSpan(text: text1),
        TextSpan(
          text: text2,
          style: AppTextStyle.fs14m.copyWith(
            color: AppColor.gray5,
          ),
        ),
      ],
    ));
  }

  ContractStatus? get status => ContractStatusX.valueOf(model.state);

  Widget buildStatus() {
    if (status == null) {
      return Spacing.blank;
    }
    Color? color;
    switch (status) {
      case ContractStatus.signing:
        color = AppColor.primary;
        break;
      case ContractStatus.signed:
        color = const Color(0xFFC644FC);
        break;
      case ContractStatus.terminated:
      case ContractStatus.reject:
        color = AppColor.gray9;
        break;
      default:
        break;
    }

    return Container(
      width: 68.rpx,
      height: 28.rpx,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: color,
      ),
      child: Text(
        status?.label ?? '',
        style: AppTextStyle.fs12m.copyWith(color: Colors.white),
      ),
    );
  }
}

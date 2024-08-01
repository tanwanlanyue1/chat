import 'package:flutter/material.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
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
                  buildRichText(S.current.broker, model.broker),
                  buildRichText(
                    status == ContractStatus.terminated
                        ? S.current.startStopTime
                        : S.current.effectiveTime,
                    model.date.isNotEmpty ? model.date : S.current.none,
                  ),
                ],
              ),
            ),
            buildStatus(),
          ],
        ),
      ),
    );
  }

  Widget buildRichText(String text1, String text2) {
    return Text.rich(TextSpan(
      style: AppTextStyle.fs14m.copyWith(
        color: AppColor.gray30,
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

  ContractStatus? get status => ContractStatusX.valueOf(model.status);

  Widget buildStatus() {
    if (status == null) {
      return Spacing.blank;
    }
    Color? color;
    switch (status) {
      case ContractStatus.unsigned:
      case ContractStatus.signing:
        color = AppColor.primary;
        break;
      case ContractStatus.signed:
        color = const Color(0xFFC644FC);
        break;
      case ContractStatus.terminated:
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

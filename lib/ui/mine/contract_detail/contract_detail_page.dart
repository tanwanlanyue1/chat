import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/mine/contract_generate/widget/contract_view.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'contract_detail_controller.dart';
import 'contract_detail_state.dart';

///契约详情
class ContractDetailPage extends GetView<ContractDetailController> {
  const ContractDetailPage({super.key});

  ContractDetailState get state => controller.state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(state.title),
      ),
      backgroundColor: AppColor.scaffoldBackground,
      body: SingleChildScrollView(
        padding: FEdgeInsets(horizontal: 16.rpx, vertical: 24.rpx),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.rpx),
            color: Colors.white,
          ),
          padding: FEdgeInsets(horizontal: 12.rpx, vertical: 36.rpx),
          child: Column(
            children: [
              ContractView(
                partyA: '小强',
                partyB: 'Hello1',
                content:
                    '  甲方/乙方双方于今日自愿结成经纪人与艺人系，关系存续期间，甲方负责乙方在管佳APP的约会接单事宜\n\n  乙方在管佳APP上获得的所有收入，将与甲方按照18%的比例分成。',
                date: DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd'),
              ),
              buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    final children = <Widget>[];
    switch (state.status) {
      case ContractStatus.unsigned:
        children.addAll([
          Button.stadium(
            width: 120.rpx,
            height: 36.rpx,
            onPressed: () {},
            backgroundColor: AppColor.gray9,
            child: Text(S.current.contractReject),
          ),
          Button.stadium(
            width: 120.rpx,
            height: 36.rpx,
            onPressed: () {},
            child: Text(S.current.contractSignNow),
          ),
        ]);
        break;
      case ContractStatus.signing:
        children.add(Text(S.current.contractSigning));
        break;
      case ContractStatus.signed:
        children.add(
          Button.stadium(
            width: 120.rpx,
            height: 36.rpx,
            onPressed: controller.terminateContract,
            backgroundColor: AppColor.gray9,
            child: Text(S.current.contractTerminateNow),
          ),
        );
        break;
      case ContractStatus.terminated:
        children.add(Text(S.current.contractTerminated));
        break;
    }

    return Padding(
      padding: FEdgeInsets(horizontal: 12.rpx, top: 80.rpx),
      child: Row(
        mainAxisAlignment: children.length > 1
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: children,
      ),
    );
  }
}

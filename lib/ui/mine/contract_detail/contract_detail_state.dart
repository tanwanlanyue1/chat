import 'package:get/get.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/generated/l10n.dart';

class ContractDetailState {
  ///合约
  final contractRx = Rxn<ContractModel>();

  ContractStatus? get statusRx => ContractStatusX.valueOf(contractRx()?.state ?? 0);

  String get titleRx {
    if (statusRx == ContractStatus.signing) {
      return S.current.contractSign;
    }
    return S.current.contractDetail;
  }
}

///签约状态
enum ContractStatus {
  ///签约中 0
  signing,

  ///已签约 1
  signed,

  ///已解除 2
  terminated,

  ///已拒绝 3
  reject,
}

extension ContractStatusX on ContractStatus {
  static ContractStatus? valueOf(int value) {
    return ContractStatus.values.elementAtOrNull(value);
  }

  String get label {
    switch (this) {
      // case ContractStatus.unsigned:
      //   return S.current.contractUnsigned;
      case ContractStatus.signing:
        return S.current.contractSigning;
      case ContractStatus.signed:
        return S.current.contractSigned;
      case ContractStatus.terminated:
        return S.current.contractTerminated;
      case ContractStatus.reject:
        return '已拒绝';
    }
  }
}

extension ContractModelX on ContractModel {
  static const _kBrokerageService = '{brokerageService}';
  static const _kBrokerageChatting = '{brokerageChatting}';

  ///完整合约内容(包含分成比例)
  String get fullContent {
    return content +
        '\n\n' +
        brokerageServiceTemplate.replaceFirst(
            _kBrokerageService, brokerageService.toPercent(scale: 1)) +
        '\n\n' +
        brokerageChattingTemplate.replaceFirst(
            _kBrokerageChatting, brokerageChatting.toPercent(scale: 1));
  }

  String get brokerageServicePlaceholder => _kBrokerageService;

  String get brokerageServiceTemplate {
    return SS.appConfig.configRx()?.brokerageServiceTemplate ??
        '乙方在App上通过约会获得的服务费收益，甲方将获得$_kBrokerageService比例提成。';
  }

  String get brokerageChattingPlaceholder => _kBrokerageChatting;

  String get brokerageChattingTemplate {
    return SS.appConfig.configRx()?.brokerageChattingTemplate ??
        '乙方在App上通过 实时视频/语音获得的陪聊收益，甲方将获得$_kBrokerageChatting比例分成。';
  }
}

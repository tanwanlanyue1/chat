import 'package:get/get.dart';
import 'package:guanjia/common/network/api/model/user/contract_model.dart';
import 'package:guanjia/generated/l10n.dart';

class ContractDetailState {

  ///合约
  final Rx<ContractModel> contractRx;

  ContractDetailState(ContractModel contract) : contractRx = contract.obs;

  ContractStatus? get statusRx => ContractStatusX.valueOf(contractRx().state);

  String get titleRx{
    if(statusRx == ContractStatus.signing){
      return S.current.contractSign;
    }
    return S.current.contractDetail;
  }
}

///签约状态 0签约中 1生效中 2已结束
enum ContractStatus{
  ///签约中 0
  signing,
  ///已签约 1
  signed,
  ///已解除 2
  terminated,
}

extension ContractStatusX on ContractStatus{

  static ContractStatus? valueOf(int value){
    return ContractStatus.values.elementAtOrNull(value);
  }

  String get label{
    switch(this){
      // case ContractStatus.unsigned:
      //   return S.current.contractUnsigned;
      case ContractStatus.signing:
        return S.current.contractSigning;
      case ContractStatus.signed:
        return S.current.contractSigned;
      case ContractStatus.terminated:
        return S.current.contractTerminated;
    }
  }
}

import 'package:guanjia/generated/l10n.dart';

class ContractDetailState {

  ///合约状态
  ContractStatus status;

  ContractDetailState(this.status) {
    ///Initialize variables
  }

  String get title{
    if(status == ContractStatus.unsigned){
      return S.current.contractSign;
    }
    return S.current.contractDetail;
  }
}

enum ContractStatus{
  ///未签约
  unsigned,
  ///签约中
  signing,
  ///已签约
  signed,
  ///已解除
  terminated,
}

extension ContractStatusX on ContractStatus{

  static ContractStatus? valueOf(int value){
    return ContractStatus.values.elementAtOrNull(value);
  }

  String get label{
    switch(this){
      case ContractStatus.unsigned:
        return S.current.contractUnsigned;
      case ContractStatus.signing:
        return S.current.contractSigning;
      case ContractStatus.signed:
        return S.current.contractSigned;
      case ContractStatus.terminated:
        return S.current.contractTerminated;
    }
  }
}

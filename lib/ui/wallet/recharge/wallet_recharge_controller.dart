import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/widgets.dart';

class WalletRechargeController extends GetxController {

  ///金额输入
  final amountEditingController = TextEditingController();

  void onSubmit() async{
    final amount = double.tryParse(amountEditingController.text) ?? 0;
    if(amount <= 0){
      Loading.showToast('充值金额必须大于0');
      return;
    }

    //TODO 接口下单



  }

}

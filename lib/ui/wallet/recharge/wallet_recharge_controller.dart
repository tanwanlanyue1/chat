import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/network/api/payment_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/widgets/widgets.dart';

class WalletRechargeController extends GetxController {

  ///金额输入
  final amountEditingController = TextEditingController();

  void onSubmit() async{
    final amount = double.tryParse(amountEditingController.text) ?? 0;
    if(amount <= 0){
      Loading.showToast('金额必须大于0');
      return;
    }

    Loading.show();
    final response = await PaymentApi.createRechargeOrder(amount);
    Loading.dismiss();
    if(response.isSuccess){
      Get.toNamed(AppRoutes.rechargeOrderPage, arguments: {
        'orderNo': response.data?.orderNo,
        'fromRechargePage': true,
      });
    }else{
      response.showErrorMessage();
    }
  }

}

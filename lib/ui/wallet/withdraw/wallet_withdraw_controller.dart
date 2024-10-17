import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/math_extension.dart';
import 'package:guanjia/common/network/api/payment_api.dart';
import 'package:guanjia/common/routes/app_pages.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/widgets/payment_password_keyboard.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'wallet_address_add_dialog.dart';

class WalletWithdrawController extends GetxController {

  final addressListRx = <String>[].obs;
  final addressRx = Rxn<String>();
  final amountEditingController = TextEditingController();

  ///提示文本
  String get descRx => SS.appConfig.configRx()?.withdrawTips ?? '';

  ///提现手续费
  String get withdrawFeeRx => SS.appConfig.configRx()?.withdrawFee?.toStringAsTrimZero() ?? '';

  @override
  void onInit() {
    super.onInit();

    _fetchData();

    ///刷新提示文本
    if(descRx.isEmpty || withdrawFeeRx.isEmpty){
      SS.appConfig.fetchData();
    }
  }

  void _fetchData() async{
    final response = await PaymentApi.getWalletAddress();
    final list = response.data ?? [];
    if(list.isNotEmpty){
      addressListRx.addAll(list);
    }
  }

  void onTapAddAddress() async{
    final address = await WalletAddressAddDialog.show();
    if(address == null || address.isEmpty){
      return;
    }
    if(addressListRx.contains(address)){
      Loading.showToast('该地址已存在，无需重复添加');
      return;
    }

    Loading.show();
    final response = await PaymentApi.setWalletAddress(address: address, type: 0);
    Loading.dismiss();
    if(response.isSuccess){
      addressListRx.add(address);
      addressRx.value ??= address;
    }else{
      response.showErrorMessage();
    }
  }

  void onTapDeleteAddress(String address) async{
    Loading.show();
    final response = await PaymentApi.setWalletAddress(address: address, type: 1);
    Loading.dismiss();
    if(response.isSuccess){
      addressListRx.remove(address);
      if(addressRx() == address){
        addressRx.value = null;
      }
    }else{
      response.showErrorMessage();
    }
  }

  void onSubmit() async{
    final amount = double.tryParse(amountEditingController.text) ?? 0;
    final withdrawMinAmount = SS.appConfig.configRx()?.withdrawMinAmount ?? 0;
    if(amount < withdrawMinAmount || amount <= 0){
      Loading.showToast('提现金额有误');
      return;
    }
    final address = addressRx();
    if(address == null || address.isEmpty){
      Loading.showToast('请选择钱包地址');
      return;
    }
    if(amount > (SS.login.info?.balance ?? 0)){
      Loading.showToast('提现金额超出当前余额');
      return;
    }
    final password = await PaymentPasswordKeyboard.show();
    if(password == null){
      return;
    }

    Loading.show();
    final response = await PaymentApi.createWithdrawOrder(
        amount: amount,
        password: password,
        address: address,
    );
    Loading.dismiss();
    if(response.isSuccess){
      Loading.showToast('提交成功');
      SS.login.fetchMyInfo();
      Get.toNamed(AppRoutes.walletOrderListPage, arguments: {
        'tabIndex': 1,
      });
    }else if(response.code == 1103){
      Loading.showToast(response.errorMessage ?? '提现金额超出当前余额');
    }else{
      response.showErrorMessage();
    }
  }

}

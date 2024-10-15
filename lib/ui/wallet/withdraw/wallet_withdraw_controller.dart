import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guanjia/widgets/widgets.dart';

import 'wallet_address_add_dialog.dart';

class WalletWithdrawController extends GetxController {

  final addressListRx = <String>[].obs;
  final addressRx = Rxn<String>();
  final amountEditingController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    addressListRx.add('TAALiTehrjjAwp8oFXddpmUUwc1t5Jz36z');
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
    addressListRx.add(address);
    addressRx.value = address;
  }

  void onTapDeleteAddress(String address) async{
    print('onTapDeleteAddress $address');
    addressListRx.remove(address);
    if(addressRx() == address){
      addressRx.value = null;
    }
  }

  void onSubmit() async{

  }

}

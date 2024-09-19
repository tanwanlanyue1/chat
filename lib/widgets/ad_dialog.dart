import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/string_extension.dart';
import 'package:guanjia/common/utils/app_link.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/welcome/welcome_storage.dart';
import 'package:guanjia/widgets/app_image.dart';

import '../common/network/api/api.dart';


///APP广告弹窗
///position:位置 1占卜主页 2取名主页 3星座主页 4运势主页 5解梦 6心愿阁 7广场 8禅房主页 9思亲河主页 10供灯祈福主页 11请符法坛主页
class AppAdDialog extends StatefulWidget {
  final AdvertisingStartupModel model;
  final String position;
  AppAdDialog._({super.key,required this.model,required this.position});

  static Future<void> show(AdvertisingStartupModel model,String position) async {
    Get.dialog<int>(
      AppAdDialog._(model: model,position: position,),
      useSafeArea: false,
    );
  }

  @override
  State<AppAdDialog> createState() => _AppAdDialogState();
}

class _AppAdDialogState extends State<AppAdDialog> {

  late AdvertisingStartupModel item;
  List<String> dialog = [];

  @override
  void initState() {
    super.initState();
    item = widget.model;
    init();
  }

  void init() async{
    dialog = await WelcomeStorage.getAdFirstOpen();
    for (var element in dialog) {
      if(element == widget.position){
        Get.back();
        return;
      }
    }
    dialog.add(widget.position);
    WelcomeStorage.saveAdFirstOpen(dialog);
  }

  setList(){
    WelcomeStorage.saveAdFirstOpen(dialog);
  }

  //广告跳转
  onTapAdvertising(){
    Get.back();
    final url = item.gotoUrl;
    if(url != null){
      AppLink.jump(
        url,
        title: item.title,
        args: item.gotoParam?.toJson(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => onTapAdvertising(),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 68.rpx * 2),
              child: CachedNetworkImage(
                width: double.infinity,
                imageUrl: item.image ?? '',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Container(
      margin: EdgeInsets.only(top: 30.rpx),
      child: GestureDetector(
        onTap: (){
          Get.back();
          setState(() {});
        },
        child: AppImage.asset('assets/images/common/close.png',width: 36.rpx,height: 36.rpx,),
      ),
    );
  }
}

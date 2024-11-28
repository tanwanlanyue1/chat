import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/event/event_bus.dart';
import 'package:guanjia/common/event/event_constant.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:guanjia/ui/plaza/widgets/publish_success.dart';
import 'package:guanjia/widgets/loading.dart';

import '../../../common/network/api/api.dart';
import 'media_upload/media_item.dart';
import 'media_upload/media_uploader.dart';
import 'release_media_state.dart';

class ReleaseMediaController extends GetxController with GetSingleTickerProviderStateMixin {

  final ReleaseMediaState state = ReleaseMediaState();
  final contentEditingController = TextEditingController();
  ///打赏金额
  final amountEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }


  ///发布
  void onSubmit() async {
    final content = contentEditingController.text.trim();
    if(content.isEmpty){
      Loading.showToast(S.current.youHaveNotContent);
      return;
    }

    final amount = double.tryParse(amountEditingController.text) ?? 0;
    if(amount <= 0 && state.isFreeRx.isFalse){
      Loading.showToast('打赏金额不能小于0');
      return;
    }

    final mediaList = List.of(state.mediaList);
    if(mediaList.isEmpty){
      Loading.showToast('请上传图片或视频');
      return;
    }

    List<String>? images;
    String? video;
    String? videoCover;

    //获取上传连接
    for (var element in mediaList) {
      final url = MediaUploader().getProgress(element.uuid)?.url;
      if(url == null){
        Loading.showToast('图片或视频未上传完成');
        return;
      }

      //视频
      if(element is VideoItem){
        final coverUrl = MediaUploader().getProgress(element.cover.uuid)?.url;
        if(coverUrl == null){
          Loading.showToast('视频封面未上传完成');
          return;
        }
        element.cover.remote = coverUrl;

        video = url;
        videoCover = coverUrl;
      }else{
        //图片
        images ??= <String>[];
        images.add(url);
      }
    }

    Loading.show();
    final response = await PlazaApi.addCommunity(
        type: 2,
        content: content,
        images: images,
        video: video,
        videoCover: videoCover,
        price: amount,
    );
    Loading.dismiss();
    if (response.isSuccess) {
      // EventBus().emit(kEventInvitationSuccess);
      // PublishSuccess.show();
      Loading.showToast('发布成功');
      Get.back();
    } else {
      response.showErrorMessage();
    }
  }

}

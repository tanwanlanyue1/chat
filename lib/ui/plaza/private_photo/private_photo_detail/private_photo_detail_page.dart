import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/ui/plaza/private_photo/private_photo_detail/private_photo_detail_state.dart';
import 'package:guanjia/ui/plaza/private_photo/private_photo_detail/widget/private_photo_gallery_view.dart';

import '../../../../common/network/api/model/plaza/plaza_list_model.dart';
import 'private_photo_detail_controller.dart';

class PrivatePhotoDetailPage extends StatelessWidget {
  PrivatePhotoDetailPage({Key? key,}) : super(key: key);
  final PrivatePhotoDetailController controller = Get.put(PrivatePhotoDetailController());
  final PrivatePhotoDetailState state = Get.find<PrivatePhotoDetailController>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

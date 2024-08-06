import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/common/network/api/user_api.dart';
import 'package:guanjia/common/service/service.dart';
import 'package:guanjia/common/utils/image_crop_page.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/widgets/loading.dart';

import 'common_bottom_sheet.dart';

/// 通用的底部相册、相机弹窗，提供点击后自动上传资源到服务端，返回url
class PhotoAndCameraBottomSheet extends StatelessWidget {
  PhotoAndCameraBottomSheet({
    super.key,
    this.limit = 1,
    this.imageQuality,
    this.onTapIndex,
    this.autoUpload = true,
    this.isCrop = false,
    this.onUploadUrls,
  });

  static void show({
    int limit = 1,
    int? imageQuality,
    Function(int)? onTapIndex,
    bool autoUpload = true,
    bool isCrop = false,
    Function(List<String>)? onUploadUrls,
  }) {
    Get.bottomSheet(
      PhotoAndCameraBottomSheet(
        limit: limit,
        imageQuality: imageQuality,
        onTapIndex: onTapIndex,
        autoUpload: autoUpload,
        isCrop: isCrop,
        onUploadUrls: onUploadUrls,
      ),
    );
  }

  final ImagePicker picker = ImagePicker();

  final loginService = SS.login;

  // 最大选择图片数量限制,默认为1
  final int limit;

  // 图片质量（0-100）
  final int? imageQuality;

  // 当前选中按钮回调 0：相册，1：拍摄 2：取消
  final Function(int)? onTapIndex;

  // 是否开启自动上传到服务器功能
  final bool autoUpload;

  /// 是否需要裁剪
  final bool isCrop;

  // 当开启自动上传后获取上传成功的url回调
  final Function(List<String>)? onUploadUrls;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      titles: const ["相册", "拍摄"],
      onTap: (index) async {
        final isPhoto = index == 0;

        // iOS端需要判断权限
        if (GetPlatform.isIOS) {
          final isGranted = isPhoto
              ? await PermissionsUtils.requestPhotosPermission()
              : await PermissionsUtils.requestCameraPermission();
          if (!isGranted) return;
        }

        onTapIndex?.call(index);

        // 如果不开启自动上传功能直接返回，由业务方自己判断调用
        if (!autoUpload) {
          return;
        }

        List<XFile> files = [];

        // 分别处理相册单张和多张、相机调用逻辑
        if (!isPhoto || (isPhoto && limit == 1)) {
          final file = await picker.pickImage(
            source: isPhoto ? ImageSource.gallery : ImageSource.camera,
          );

          if (file != null) files.add(file);
        } else {
          final List<XFile> fs = await picker.pickMultiImage(
            imageQuality: imageQuality,
            limit: limit,
          );
          files.addAll(fs);
        }

        //未选择图片
        if (files.isEmpty) {
          return;
        }

        //裁剪图片(单张)
        if(files.length == 1 && isCrop){
          final bytes = await ImageCropPage.go(imageAsset: files.first, cropAspectRatio: 1.0, maxResolution: 1024*1024);
          if(bytes == null){
            //取消
            return;
          }
          Loading.show();
          final url = await _uploadImageBytes(bytes, files.first.name);
          Loading.dismiss();
          if(url == null){
            Loading.showToast("图片上传失败，请重新尝试");
            return;
          }
          onUploadUrls?.call([url]);
          return;
        }

        //多张
        Loading.show();
        final urls = await _uploadImage(files);
        Loading.dismiss();

        if (urls.isEmpty || urls.length != files.length) {
          Loading.showToast("图片上传失败，请重新尝试");
          return;
        }

        onUploadUrls?.call(urls);
      },
    );
  }

  Future<List<String>> _uploadImage(List<XFile> files) async {
    List<String> list = List<String>.filled(files.length, '');

    List<Future<void>> uploadTasks = [];

    for (int i = 0; i < files.length; i++) {
      final element = files[i];
      uploadTasks.add(
        () async {
          final res = await UserApi.upload(filePath: element.path);
          final data = res.data;

          if (res.isSuccess && data != null) {
            list[i] = data;
          }
        }(),
      );
    }

    await Future.wait(uploadTasks);

    return list.where((url) => url.isNotEmpty).toList();
  }

  Future<String?> _uploadImageBytes(Uint8List bytes, String? filename) async {
    final res = await UserApi.uploadImageBytes(data: bytes, fileName: filename);
    final data = res.data;
    if (res.isSuccess && data != null) {
      return data;
    }else{
      return null;
    }
  }
}

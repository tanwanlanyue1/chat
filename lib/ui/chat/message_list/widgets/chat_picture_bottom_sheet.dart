import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/utils/permissions_utils.dart';
import 'package:guanjia/widgets/common_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';

///聊天图片选择、拍摄图片
class ChatPictureBottomSheet extends StatelessWidget {
  ChatPictureBottomSheet._({
    super.key,
    this.limit = 1,
    this.imageQuality,
    this.onSelectedFiles,
  });

  static void show({
    int limit = 9,
    int? imageQuality,
    Function(List<XFile> files)? onSelectedFiles,
  }) {
    Get.bottomSheet<List<XFile>>(
      ChatPictureBottomSheet._(
        limit: limit,
        imageQuality: imageQuality,
        onSelectedFiles: onSelectedFiles,
      ),
    );
  }

  final ImagePicker picker = ImagePicker();

  // 最大选择图片数量限制,默认为9
  final int limit;

  // 图片质量（0-100）
  final int? imageQuality;

  ///选中的图片
  final void Function(List<XFile> files)? onSelectedFiles;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      titles: const ["相册", "拍摄"],
      autoBack: true,
      onTap: (index) async {
        final isGallery = index == 0;

        // iOS端需要判断权限
        if (GetPlatform.isIOS) {
          final isGranted = isGallery
              ? await PermissionsUtils.requestPhotosPermission()
              : await PermissionsUtils.requestCameraPermission();
          if (!isGranted) return;
        }

        List<XFile> files = [];

        // 分别处理相册单张和多张、相机调用逻辑
        if (!isGallery || (isGallery && limit == 1)) {
          final file = await picker.pickImage(
            source: isGallery ? ImageSource.gallery : ImageSource.camera,
          );

          if (file != null) files.add(file);
        } else {
          files = await picker.pickMultiImage(
            imageQuality: imageQuality,
            limit: limit,
          );
        }

        //未选择图片
        if (files.isNotEmpty) {
          onSelectedFiles?.call(files);
        }
      },
    );
  }

}

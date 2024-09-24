import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/generated/l10n.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guanjia/widgets/widgets.dart';

///图片裁剪
class ImageCropPage extends StatefulWidget {

  ///默认裁剪后最大分辨率 1179 * 2556
  static const _defaultMaxResolution = 3013524.0;

  final String? title;
  final double? cropAspectRatio;
  final double? maxResolution;
  final XFile imageAsset;

  const ImageCropPage._({
    Key? key,
    this.title,
    required this.imageAsset,
    this.cropAspectRatio,
    this.maxResolution,
  }) : super(key: key);

  ///图片裁剪
  ///- imageAsset 原始图片
  ///- title 裁剪页面标题
  ///- cropAspectRatio 裁剪比例，如果为null则用户可自由调整
  ///- maxResolution 裁剪后最大分辨率，默认[ImageCropPage._defaultMaxResolution]，传入null则不进行缩放
  static Future<Uint8List?> go({
    required XFile imageAsset,
    String? title,
    double? cropAspectRatio,
    double? maxResolution = _defaultMaxResolution,
  }) {
    final future = Get.to<Uint8List>(() => ImageCropPage._(
          imageAsset: imageAsset,
          title: title,
          cropAspectRatio: cropAspectRatio,
          maxResolution: maxResolution,
        ));
    return future ?? Future.value(null);
  }

  @override
  State<ImageCropPage> createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  final editorKey = GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const AppBackButton(brightness: Brightness.light),
        title: Text(widget.title ?? S.current.pictureCrop, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _cropImage,
            child: Text(S.current.confirm, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: ExtendedImage.file(
        extendedImageEditorKey: editorKey,
        File(widget.imageAsset.path),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        cacheRawData: true,
        initEditorConfigHandler: (state) {
          return EditorConfig(
            cropAspectRatio: widget.cropAspectRatio,
            initialCropAspectRatio: widget.cropAspectRatio,
            lineColor: Colors.white,
            cornerColor: Colors.white,
            cropRectPadding: const EdgeInsets.all(24),
            editorMaskColorHandler: (_, pointerDown) => Colors.black.withOpacity(0.7),
          );
        },
      ),
    );
  }

  void _cropImage() async {
    final state = editorKey.currentState;
    if (state == null) {
      Get.back();
      return;
    }
    Loading.show();
    var cropRect = state.getCropRect()!;
    if (state.widget.extendedImageState.imageProvider is ExtendedResizeImage) {
      final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(state.rawImageData);
      final ImageDescriptor descriptor = await ImageDescriptor.encoded(buffer);

      final double widthRatio = descriptor.width / state.image!.width;
      final double heightRatio = descriptor.height / state.image!.height;
      cropRect = Rect.fromLTRB(
        cropRect.left * widthRatio,
        cropRect.top * heightRatio,
        cropRect.right * widthRatio,
        cropRect.bottom * heightRatio,
      );
    }

    final EditActionDetails action = state.editAction!;
    final int rotateAngle = action.rotateAngle.toInt();
    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    if (action.needCrop) {
      option.addOption(ClipOption.fromRect(cropRect));
    }

    if (action.needFlip) {
      option.addOption(FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    }

    if (action.hasRotateAngle) {
      option.addOption(RotateOption(rotateAngle));
    }

    final maxResolution = widget.maxResolution ?? 0;
    if(maxResolution > 0){
      final scale = maxResolution / (cropRect.width * cropRect.height) * 2;
      if(scale > 0 && scale < 1){
        option.addOption(
          ScaleOption((cropRect.width * scale).toInt(), (cropRect.height * scale).toInt()),
        );
      }
    }

    option.outputFormat = const OutputFormat.jpeg(80);
    final result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );
    Loading.dismiss();
    Get.back(result: result);
  }
}

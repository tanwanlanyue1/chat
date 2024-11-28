import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/plaza/release_media/media_upload/media_item.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:video_editor/video_editor.dart';

import 'export_service.dart';

///获取视频封面
class VideoCoverPicker extends StatefulWidget {
  final String filepath;

  const VideoCoverPicker._({super.key, required this.filepath});

  static Future<String?> open({required String filepath}) async {
    return Get.to(() => VideoCoverPicker._(filepath: filepath));
  }

  @override
  State<VideoCoverPicker> createState() => _VideoCoverPickerState();
}

class _VideoCoverPickerState extends State<VideoCoverPicker> {
  late final VideoEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoEditorController.file(
      File(widget.filepath),
      minDuration: const Duration(seconds: 1),
      maxDuration: Duration(minutes: 5),
      coverThumbnailsQuality: 100,
    );
    controller
        .initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      Get.back();
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: AppBackButton.light(),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: controller.initialized ? onTapConfirm : null,
            child: Text(
              '确定',
              style: AppTextStyle.fs14m.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: controller.initialized ? buildBody() : buildLoading(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: SizedBox(
        width: 48.rpx,
        height: 48.rpx,
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildBody() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildPreview(),
          buildSelection(),
        ],
      ),
    );
  }

  Widget buildPreview() {
    return Expanded(
      child: CoverViewer(controller: controller),
    );
  }

  Widget buildSelection() {
    return Container(
      height: 200.rpx,
      margin: FEdgeInsets(top: 16.rpx),
      child: SingleChildScrollView(
        child: CoverSelection(
          controller: controller,
          size: 80.rpx,
          quantity: 9,
          selectedCoverBuilder: (cover, size) {
            return Stack(
              alignment: Alignment.center,
              children: [
                cover,
                Icon(
                  Icons.check_circle,
                  color: const CoverSelectionStyle().selectedBorderColor,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void onTapConfirm() async {
    Loading.show();
    final config = CoverFFmpegVideoEditorConfig(controller);
    final execute = await config.getExecuteConfig();
    if (execute == null) {
      Loading.dismiss();
      Loading.showToast("Error on cover exportation initialization.");
      return;
    }
    await ExportService.runFFmpegCommand(
      execute,
      onError: (e, s) {
        if (mounted) {
          Loading.showToast("Error on cover exportation :(");
          Loading.dismiss();
        }
      },
      onCompleted: (result) {
        if (mounted) {
          Loading.dismiss();
          Get.back(result: result.path);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

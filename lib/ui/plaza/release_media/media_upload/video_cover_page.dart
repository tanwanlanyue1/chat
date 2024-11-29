import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_config.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/widgets.dart';
import 'package:video_editor/video_editor.dart';

import 'ffmpeg_utils.dart';


///获取视频封面页
class VideoCoverPage extends StatefulWidget {
  final File file;

  const VideoCoverPage._({super.key, required this.file});

  static Future<File?> open({required File file}) async {
    return Get.to(() => VideoCoverPage._(file: file));
  }

  @override
  State<VideoCoverPage> createState() => _VideoCoverPageState();
}

class _VideoCoverPageState extends State<VideoCoverPage> {
  late final VideoEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoEditorController.file(
      widget.file,
      minDuration: AppConfig.videoMinDuration,
      maxDuration: AppConfig.videoMaxDuration,
      coverThumbnailsQuality: 100,
    );
    controller
        .initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
          AppLogger.w(error);
          Loading.showToast('初始化失败');
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
    await FFmpegUtils.runCommand(
      execute,
      onError: (e, s) {
        if (mounted) {
          Loading.showToast("Error on cover exportation :(");
          Loading.dismiss();
        }
      },
      onCompleted: (file) {
        if (mounted) {
          Loading.dismiss();
          Get.back(result: file);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    FFmpegUtils.dispose();
    controller.dispose();
  }
}

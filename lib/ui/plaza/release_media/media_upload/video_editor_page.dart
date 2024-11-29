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

class VideoEditorPage extends StatefulWidget {
  const VideoEditorPage._({super.key, required this.file});

  final File file;

  static Future<File?> open({required File file}) async {
    return Get.to(() => VideoEditorPage._(file: file));
  }

  @override
  State<VideoEditorPage> createState() => _VideoEditorPageState();
}

class _VideoEditorPageState extends State<VideoEditorPage> {
  late final VideoEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoEditorController.file(
      widget.file,
      minDuration: AppConfig.videoMinDuration,
      maxDuration: AppConfig.videoMaxDuration,
      trimThumbnailsQuality: 100,
    );
    controller
        .initialize(aspectRatio: 9 / 16)
        .then((_) => setState(() {}))
        .catchError((error) {
      AppLogger.w(error);
      Loading.showToast('初始化失败');
    }, test: (e) => e is VideoMinDurationError);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) async {
        if(canPop){
          return;
        }
        final result = await ConfirmDialog.show(message: Text('确定返回吗？'));
        if (result) {
          Get.back();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: AppBackButton.light(),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: controller.initialized ? onTapSave : null,
              child: Text(
                '保存',
                style: AppTextStyle.fs14m.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        body: controller.initialized ? buildBody() : buildLoading(),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: SizedBox(
        width: 48.rpx,
        height: 48.rpx,
        child: const CircularProgressIndicator(
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
          Expanded(child: buildPreview()),
          buildTrimSlider(),
        ],
      ),
    );
  }

  Widget buildPreview() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CropGridViewer.preview(controller: controller),
        AnimatedBuilder(
          animation: controller.video,
          builder: (_, __) => AnimatedOpacity(
            opacity: controller.isPlaying ? 0 : 1,
            duration: kThemeAnimationDuration,
            child: GestureDetector(
              onTap: controller.video.play,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTrimSlider() {
    final height = 80.rpx;
    return Container(
      padding: FEdgeInsets(vertical: 16.rpx),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([
              controller,
              controller.video,
            ]),
            builder: (_, __) {
              final int duration = controller.videoDuration.inSeconds;
              final double pos = controller.trimPosition * duration;
              return DefaultTextStyle(
                style: const TextStyle(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: height / 4),
                  child: Row(children: [
                    Text(formatter(Duration(seconds: pos.toInt()))),
                    const Expanded(child: SizedBox()),
                    AnimatedOpacity(
                      opacity: controller.isTrimming ? 1 : 0,
                      duration: kThemeAnimationDuration,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(formatter(controller.startTrim)),
                        const SizedBox(width: 10),
                        Text(formatter(controller.endTrim)),
                      ]),
                    ),
                  ]),
                ),
              );
            },
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: height / 4),
            child: TrimSlider(
              controller: controller,
              height: height,
              horizontalMargin: height / 4,
              child: TrimTimeline(
                controller: controller,
                padding: const EdgeInsets.only(top: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  void onTapSave() async {
    Loading.show();
    final config = VideoFFmpegVideoEditorConfig(controller);
    await FFmpegUtils.runCommand(
      await config.getExecuteConfig(),
      onProgress: (stats) {
        final progress = config.getFFmpegProgress(stats.getTime());
        AppLogger.d('export video progress=$progress');
      },
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

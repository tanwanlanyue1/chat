import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/paging/default_status_indicators/first_page_progress_indicator.dart';
import 'package:guanjia/ui/plaza/release_media/media_upload/media_item.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:guanjia/widgets/system_ui.dart';
import 'package:video_player/video_player.dart';

import 'package:zego_zimkit/src/components/messages/video_message_controls.dart';
import 'package:zego_zimkit/src/components/messages/video_message_preview.dart';
import 'package:zego_zimkit/src/services/logger_service.dart';
import 'package:zego_zimkit/src/services/services.dart';

///视频预览播放器
class VideoPreviewPlayer extends StatefulWidget {
  final VideoItem item;

  const VideoPreviewPlayer._(this.item, {super.key});

  static void show(VideoItem item){
    Get.to(() => VideoPreviewPlayer._(item));
  }

  @override
  State<VideoPreviewPlayer> createState() => _VideoPreviewPlayerState();
}

class _VideoPreviewPlayerState extends State<VideoPreviewPlayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;

  @override
  Future<void> dispose() async {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    final local = widget.item.local ?? '';
    final remote = widget.item.remote ?? '';
    if (local.isNotEmpty &&
        (local.endsWith('mp4') || local.endsWith('mov')) &&
        File(local).existsSync()) {
      videoPlayerController = VideoPlayerController.file(File(local));
    } else {
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(remote));
    }
    await videoPlayerController.initialize();
    createChewieController();
    setState(() {});
  }

  void createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      looping: false,
      autoPlay: true,
      autoInitialize: true,
      showControlsOnInitialize: false,
      allowedScreenSleep: false,
      showOptions: false,
      allowFullScreen: false,
      customControls: const MaterialControls(),
      // materialProgressColors: ChewieProgressColors(
      //   backgroundColor: Colors.white,
      //   bufferedColor: AppColor.primary.withOpacity(0.1),
      //   playedColor: AppColor.primary,
      // ),
      placeholder: const FirstPageProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = this.chewieController;
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton.light(),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUI.lightStyle,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: (chewieController != null &&
              chewieController.videoPlayerController.value.isInitialized)
          ? Chewie(
              key: ValueKey(widget.item.uuid),
              controller: chewieController,
            )
          : const FirstPageProgressIndicator(),
    );
  }
}

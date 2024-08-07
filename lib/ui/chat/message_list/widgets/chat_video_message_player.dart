
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:guanjia/widgets/app_back_button.dart';
import 'package:video_player/video_player.dart';

import 'package:zego_zimkit/src/components/messages/video_message_controls.dart';
import 'package:zego_zimkit/src/components/messages/video_message_preview.dart';
import 'package:zego_zimkit/src/services/logger_service.dart';
import 'package:zego_zimkit/src/services/services.dart';

///视频消息播放器
class ChatVideoMessagePlayer extends StatefulWidget {
  const ChatVideoMessagePlayer(this.message, {super.key});

  final ZIMKitMessage message;

  @override
  State<ChatVideoMessagePlayer> createState() =>
      _ChatVideoMessagePlayerState();
}

class _ChatVideoMessagePlayerState extends State<ChatVideoMessagePlayer> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  late Future<void> initing;

  @override
  Future<void> dispose() async {
    videoPlayerController.dispose();
    chewieController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.message.videoContent!.fileLocalPath.isNotEmpty &&
        (widget.message.videoContent!.fileLocalPath.endsWith('mp4') ||
            widget.message.videoContent!.fileLocalPath.endsWith('mov')) &&
        File(widget.message.videoContent!.fileLocalPath).existsSync()) {
      ZIMKitLogger.fine('ZIMKitVideoMessagePlayer: initPlayer from local '
          'file: ${widget.message.videoContent!.fileLocalPath}');
      videoPlayerController = VideoPlayerController.file(
        File(
          /*Uri.encodeComponent*/
          widget.message.videoContent!.fileLocalPath,
        ),
      );
    } else {
      ZIMKitLogger.fine(
        'ZIMKitVideoMessagePlayer: initPlayer from network: '
            '${widget.message.videoContent!.fileDownloadUrl}',
      );
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.message.videoContent!.fileDownloadUrl),
      );
    }

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      looping: true,
      showControlsOnInitialize: false,
      customControls: const ZIMKitCustomControls(),
      placeholder: Center(
        child: ZIMKitVideoMessagePreview(
          widget.message,
          key: ValueKey(widget.message.info.messageID),
        ),
      ),
    )
      ..setVolume(1.0)
      ..play();

    initing = videoPlayerController.initialize();

    Future.delayed(const Duration(seconds: 4)).then(
          (value) {
        if (!chewieController.videoPlayerController.value.isInitialized) {
          ZIMKitLogger.severe(
              'videoPlayerController is not initialized, ${widget.message.videoContent!.fileLocalPath}');
          ZIMKitLogger.shout(context,
              "Seems Can't play this video, ${widget.message.videoContent!.fileLocalPath}");
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton.light(),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: initing,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            ZIMKitLogger.fine(
                'ZIMKitVideoMessagePlayer: videoPlayerController initialize done');
            return Chewie(
              key: ValueKey(widget.message.info.messageID),
              controller: chewieController,
            );
          } else {
            ZIMKitLogger.fine(
                'ZIMKitVideoMessagePlayer: videoPlayerController initializing...');
            return Chewie(
              key: ValueKey(snapshot.hashCode),
              controller: chewieController,
            );
          }
        },
      ),
    );
  }
}

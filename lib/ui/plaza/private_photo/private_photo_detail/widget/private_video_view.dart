import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../../../common/network/api/model/plaza/plaza_list_model.dart';
import '../../../../../common/paging/default_status_indicators/first_page_progress_indicator.dart';
import 'bottom_review.dart';

class PrivateVideoView extends StatefulWidget {
  const PrivateVideoView({super.key, required this.item});
  final PlazaListModel item;
  static void show(BuildContext context, PrivateVideoView galleryPage) {
    Navigator.of(context).push(
      FadeRoute(
        page: galleryPage,
      ),
    );
  }

  @override
  State<PrivateVideoView> createState() => _PrivateVideoViewState();
}

class _PrivateVideoViewState extends State<PrivateVideoView> {

  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController ;
  @override
  void initState() {
    super.initState();
    //createChewieController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createChewieController(), // 调用异步方法
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return Column(children: [
            Expanded(
                child: Chewie(
              key: ValueKey("https://media.w3.org/2010/05/sintel/trailer.mp4"),
              controller: chewieController!,
            )),
            BottomReview(
              user: false,
              item: widget.item,
            )
          ]);
        } else {
          return const FirstPageProgressIndicator();
        }
      },
    );
  }

  Future<void> createChewieController() async {
    videoPlayerController =
        VideoPlayerController.networkUrl(
          Uri.parse(widget.item.video??''),
        );
    await videoPlayerController.initialize();
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
      placeholder: const FirstPageProgressIndicator(),
    );
  }
}

//渐隐动画
class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}

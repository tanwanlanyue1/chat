import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:svgaplayer_flutter/proto/svga.pb.dart';

///SVAG动画
class SVGAView extends StatefulWidget {
  final String? resUrl;
  final String? assetsName;
  final bool repeat;
  final BoxFit fit;
  final FilterQuality filterQuality;
  final bool? allowDrawingOverflow;
  final bool clearsAfterStop;
  final Size? preferredSize;
  final ValueChanged<SVGAAnimationController>? onAnimationControllerUpdate;
  final ValueChanged<AnimationStatus>? onStatusUpdate;

  ///SVAG动画
  ///- resUrl
  ///- assetsName
  ///- repeat
  ///- preferredSize
  const SVGAView({
    super.key,
    this.resUrl,
    this.assetsName,
    this.repeat = true,
    this.fit = BoxFit.contain,
    this.filterQuality = FilterQuality.medium,
    this.allowDrawingOverflow,
    this.clearsAfterStop = true,
    this.preferredSize,
    this.onAnimationControllerUpdate,
    this.onStatusUpdate,
  });

  @override
  State<SVGAView> createState() => _SVGAViewState();
}

class _SVGAViewState extends State<SVGAView>
    with SingleTickerProviderStateMixin {
  late SVGAAnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = SVGAAnimationController(vsync: this);

    animationController.addListener(() {
      widget.onAnimationControllerUpdate?.call(animationController);
    });
    animationController.addStatusListener((status) {
      widget.onStatusUpdate?.call(status);
    });
    _tryDecodeSvga();
  }

  @override
  void didUpdateWidget(covariant SVGAView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resUrl != widget.resUrl ||
        oldWidget.assetsName != widget.assetsName) {
      _tryDecodeSvga();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SVGAImage(
      animationController,
      fit: widget.fit,
      filterQuality: widget.filterQuality,
      allowDrawingOverflow: widget.allowDrawingOverflow,
      clearsAfterStop: widget.clearsAfterStop,
      preferredSize: widget.preferredSize,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _tryDecodeSvga() async {
    try {
      MovieEntity? videoItem;
      if (widget.resUrl != null) {
        final file = await DefaultCacheManager().getSingleFile(widget.resUrl!);
        videoItem =
            await SVGAParser.shared.decodeFromBuffer(await file.readAsBytes());
      } else if (widget.assetsName != null) {
        videoItem =
            await SVGAParser.shared.decodeFromAssets(widget.assetsName!);
      }
      if (mounted && videoItem != null) {
        animationController.videoItem = videoItem;
        if (widget.repeat) {
          animationController.repeat();
        } else {
          animationController.forward();
        }
      } else {
        videoItem?.dispose();
      }
    } catch (ex) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: ex,
        library: 'svga library',
        informationCollector: () => [
          if (widget.resUrl != null) StringProperty('resUrl', widget.resUrl),
          if (widget.assetsName != null)
            StringProperty('assetsName', widget.assetsName),
        ],
      ));
    }
  }
}

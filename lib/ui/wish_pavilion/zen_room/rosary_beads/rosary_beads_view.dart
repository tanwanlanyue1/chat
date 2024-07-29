import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/widgets.dart';

///佛珠控件
class RosaryBeadsView extends StatefulWidget {
  final String imageUrl;
  final int mode;
  final bool isSoundEnabled;
  final VoidCallback? onIncrement;

  ///佛珠控件
  ///- imageUrl 佛珠图片
  ///- mode 交互方式 0点击，1滑动
  ///- isSoundEnabled 是否启用音效
  ///- onIncrement 累计次数回调
  const RosaryBeadsView({
    super.key,
    required this.imageUrl,
    this.mode = 0,
    this.isSoundEnabled = true,
    this.onIncrement,
  });

  @override
  State<RosaryBeadsView> createState() => _RosaryBeadsViewState();
}

class _RosaryBeadsViewState extends State<RosaryBeadsView> {
  final controller = ScrollController();
  final itemExtent = 66.rpx;
  late Soundpool _soundPool;

  /// 念珠声音ID
  late int _rosaryBeadsSoundId;
  int? _rosaryBeadsStreamId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    // 加载音效
    _soundPool = Soundpool.fromOptions(
        options: const SoundpoolOptions(
          streamType: StreamType.music,
          maxStreams: 1,
        ));

    var data = await rootBundle.load('assets/audio/佛珠.mp3');
    _rosaryBeadsSoundId = await _soundPool.load(data);
  }


  @override
  void dispose() {
    controller.dispose();
    _soundPool.dispose();
    super.dispose();
  }

  void increment() async{
    widget.onIncrement?.call();

    //滚动特效
    final offset = controller.offset + itemExtent;
    controller.animateTo(
      offset,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );

    //播放音效
    if(widget.isSoundEnabled){
      final streamId = _rosaryBeadsStreamId ?? 0;
      if(streamId > 0){
        _soundPool.stop(streamId);
      }
      _rosaryBeadsStreamId = await _soundPool.play(_rosaryBeadsSoundId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.mode == 0) {
          increment();
        }
      },
      onVerticalDragEnd: (_) {
        if (widget.mode == 1) {
          increment();
        }
      },
      child: Container(
        width: itemExtent,
        height: itemExtent * 6,
        margin: FEdgeInsets(horizontal: 64.rpx),
        child: FadingEdgeScrollView.fromScrollView(
          child: ListView.builder(
            controller: controller,
            padding: FEdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: itemExtent,
            reverse: true,
            itemBuilder: (_, index) {
              return widget.imageUrl.startsWith('http')
                  ? AppImage.network(
                      width: itemExtent,
                      height: itemExtent,
                      widget.imageUrl,
                    )
                  : AppImage.asset(
                      width: itemExtent,
                      height: itemExtent,
                      'assets/images/wish_pavilion/zen_room/beads1.png',
                    );
            },
          ),
        ),
      ),
    );
  }
}

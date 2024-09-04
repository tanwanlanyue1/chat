import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/home/home_state.dart';
import 'package:guanjia/widgets/app_image.dart';
import 'package:guanjia/widgets/edge_insets.dart';
import 'package:guanjia/widgets/foreground_gradient_mask.dart';
import 'package:lottie/lottie.dart';

typedef AppNavigationIconBuilder = Widget Function(AppBarItem item, Widget icon);

class AppNavigationBar extends StatefulWidget {
  final List<AppBarItem> items;
  final ValueChanged<int>? onTap;
  final int currentIndex;
  final AppNavigationIconBuilder? iconBuilder;

  const AppNavigationBar({
    super.key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.iconBuilder
  });

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar>
    with TickerProviderStateMixin {
  var _controllers = <AnimationController>[];
  var _animations = <CurvedAnimation>[];
  _IndicatorAnimationController? _indicatorController;

  @override
  initState() {
    super.initState();
    _resetState();
  }

  @override
  void dispose() {
    for (final AnimationController controller in _controllers) {
      controller.dispose();
    }
    _indicatorController?.dispose();
    super.dispose();
  }

  void _resetState() {
    if (_indicatorController != null) {
      _indicatorController?.dispose();
    }
    _indicatorController = _IndicatorAnimationController(
      vsync: this,
      currentIndex: widget.currentIndex,
      itemWidth: Get.width / widget.items.length,
      duration: const Duration(milliseconds: 175),
    );
    _indicatorController?.value = 1;

    for (final AnimationController controller in _controllers) {
      controller.dispose();
    }
    _controllers =
        List<AnimationController>.generate(widget.items.length, (int index) {
      return AnimationController(
        duration: const Duration(milliseconds: 175),
        vsync: this,
      );
    });
    _animations =
        List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.decelerate,
        reverseCurve: Curves.linear,
      );
    });
    _controllers[widget.currentIndex].value = 1.0;
  }

  @override
  void didUpdateWidget(AppNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items.length != oldWidget.items.length) {
      _resetState();
      return;
    }

    if (widget.currentIndex != oldWidget.currentIndex) {
      _indicatorController
        ?..setCurrentIndex(widget.currentIndex)
        ..reset()
        ..forward();
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.white,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: Stack(
          children: [
            _buildNavigationBackground(),
            _buildHighlightIndicator(),
            _buildNavigationForeground(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationForeground() {
    return Row(
      children: widget.items.mapIndexed((index, item) {
        return Expanded(
          child:  _Tile(
            item: item,
            selected: widget.currentIndex == index,
            animation: _animations[index],
            iconBuilder: widget.iconBuilder,
            onTap: () {
              widget.onTap?.call(index);
            },
          ),
        );
      }).toList(growable: false),
    );
  }

  Widget _buildNavigationBackground() {
    return Row(
      children: widget.items.mapIndexed((index, item) {
        return Expanded(
          child: _Tile(
            item: item,
            onTap: () {
              widget.onTap?.call(index);
            },
          ),
        );
      }).toList(growable: false),
    );
  }

  Widget _buildHighlightIndicator() {
    final controller = _indicatorController;
    if (controller == null) {
      return const SizedBox.shrink();
    }
    final dx = (controller.itemWidth - 32.rpx) * 0.5;
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (ctx, _, child) {
        final offset = controller.offset;
        return Positioned(
          top: 6.rpx,
          left: offset.dx + dx,
          child: Container(
            width: 32.rpx,
            height: 32.rpx,
            decoration: const ShapeDecoration(
              shape: CircleBorder(),
              gradient: AppColor.horizontalGradient,
            ),
          ),
        );
      },
    );
    ;
  }
}

class _Tile extends StatelessWidget {
  final AppBarItem item;
  final bool selected;
  final Animation<double>? animation;
  final VoidCallback? onTap;
  final AppNavigationIconBuilder? iconBuilder;

  const _Tile({
    super.key,
    required this.item,
    this.selected = false,
    this.onTap,
    this.animation,
    this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _TileIcon(
      key: ObjectKey(item),
      item: item,
      selected: selected,
      animation: animation,
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: FEdgeInsets(vertical: 6.rpx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconBuilder?.call(item, icon) ?? icon,
            Padding(
              padding: FEdgeInsets(top: 4.rpx),
              child: ForegroundGradientMask(
                gradient: AppColor.verticalGradient,
                isMask: selected,
                child: Text(
                  item.title,
                  style: AppTextStyle.fs12m.copyWith(
                    height: 1.0,
                    color: animation == null
                        ? Colors.transparent
                        : (selected ? Colors.white : AppColor.tab),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  final AppBarItem item;
  final bool selected;
  final Animation<double>? animation;

  const _TileIcon({
    super.key,
    required this.item,
    this.selected = false,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final animation = this.animation;
    return SizedBox(
      width: 32.rpx,
      height: 32.rpx,
      child: animation == null
          ? AppImage.asset(
              item.icon,
            )
          : AnimatedBuilder(
              animation: animation,
              builder: (ctx, child) {
                if (animation.value >= 1) {
                  return Lottie.asset(item.activeIcon, repeat: false);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
    );
  }
}

class _IndicatorAnimationController extends AnimationController {
  late CurvedAnimation txAnimation;
  final double itemWidth;
  int currentIndex;
  late Tween<double> txTween;
  double txBegin = 0;

  _IndicatorAnimationController({
    required super.vsync,
    required this.itemWidth,
    required this.currentIndex,
    super.duration,
  }) {
    txAnimation = CurvedAnimation(
      parent: this,
      curve: Curves.decelerate,
      reverseCurve: Curves.linear,
    );
    setCurrentIndex(currentIndex);
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    final txEnd = index * itemWidth;
    txTween = Tween<double>(begin: txBegin, end: txEnd);
  }

  Offset get offset {
    final tx = txTween.evaluate(txAnimation);
    txBegin = tx;
    return Offset(tx, 0);
  }
}

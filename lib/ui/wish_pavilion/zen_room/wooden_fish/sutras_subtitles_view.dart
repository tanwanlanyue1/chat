import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/app_color.dart';
import 'package:guanjia/common/app_text_style.dart';
import 'package:guanjia/common/paging/default_status_indicators/first_page_error_indicator.dart';
import 'package:guanjia/common/paging/default_status_indicators/first_page_progress_indicator.dart';
import 'package:guanjia/common/utils/app_logger.dart';
import 'package:guanjia/common/utils/screen_adapt.dart';
import 'package:guanjia/ui/wish_pavilion/zen_room/utils/sutras_subtitle_utils.dart';
import 'package:guanjia/widgets/widgets.dart';

import '../../../../common/network/api/model/wish_pavilion/talk_wish_pavilion.dart';

///经书字幕控件
class SutrasSubtitlesView extends StatelessWidget {
  final SutrasSubtitlesController controller;
  static double get itemExtent => 24.rpx;

  const SutrasSubtitlesView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        controller.setMaxHeight(constraints.maxHeight);
        return AnimatedBuilder(
          animation: controller,
          builder: (_, child) {
            switch(controller.state){
              case SutrasSubtitlesStatus.idle:
                return Spacing.blank;
              case SutrasSubtitlesStatus.loading:
                return const FirstPageProgressIndicator();
              case SutrasSubtitlesStatus.error:
                return const FirstPageErrorIndicator(title: '加载失败');
              case SutrasSubtitlesStatus.success:
                final list = controller.lines;
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemExtent: itemExtent,
                  padding: FEdgeInsets.zero,
                  controller: controller.scrollController,
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    final item = list[index];
                    return buildItem(item, index);
                  },
                );
            }
          },
        );
      },
    );
  }

  Widget buildItem(String item, int row) {
    final textStyle = AppTextStyle.fs14m.copyWith(color: AppColor.gray2);
    final currentTextItem = controller.textItem;
    if (currentTextItem == null || currentTextItem.row != row) {
      return Container(
        height: itemExtent,
        alignment: Alignment.center,
        child: Text(item, style: textStyle, textAlign: TextAlign.center),
      );
    }

    final children = <TextSpan>[];
    final tuple = item.splitWithIndex(currentTextItem.index);
    if (tuple.$1 != null) {
      children.add(TextSpan(text: tuple.$1));
    }
    if (tuple.$2 != null) {
      children.add(
        TextSpan(
          text: tuple.$2,
          style: const TextStyle(color: AppColor.gold),
        ),
      );
    }
    if (tuple.$3 != null) {
      children.add(TextSpan(text: tuple.$3));
    }
    if(children.isEmpty){
      print('=====$item, $row, $currentTextItem');
    }
    return Container(
      height: itemExtent,
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(children: children),
        textAlign: TextAlign.center,
        style: textStyle.copyWith(color: Colors.white),
      ),
    );
  }
}

class SutrasSubtitlesController extends ChangeNotifier {
  TextItem? _textItem;
  BuddhistSutrasModel? buddhistSutras;

  TextItem? get textItem => _textItem;

  set textItem(TextItem? value) {
    _textItem = value;
    notifyListeners();
  }

  ///经文总字数(排除标点符号)
  var total = 0;

  var _state = SutrasSubtitlesStatus.idle;

  set state(SutrasSubtitlesStatus value) {
    _state = value;
    notifyListeners();
  }

  SutrasSubtitlesStatus get state => _state;

  ///每个字所在行的位置
  final items = <TextItem>[];
  var lines = <String>[];

  final scrollController = ScrollController();
  var maxHeight = 0.0;

  ///设置列表控件高度
  void setMaxHeight(double height){
    maxHeight = height;
  }

  ///设置字幕文件
  Future<void> setBuddhistSutras(BuddhistSutrasModel data) async {
    if(buddhistSutras?.id == data.id){
      return;
    }
    buddhistSutras = data;

    //重置状态
    if(lines.isNotEmpty){
      total = 0;
      lines.clear();
      items.clear();
      _textItem = null;
      scrollController.jumpTo(0);
      notifyListeners();
    }

    //是否有经文内容文件
    final hasContent = data.content.startsWith('http');
    //是否有音频字幕文件
    final hasSubtitles = data.subtitles.startsWith('http');
    if (!hasContent && !hasSubtitles) {
      return;
    }

    state = SutrasSubtitlesStatus.loading;
    try {
      if(hasContent){
        lines = await SutrasSubtitleUtils.getSutrasLines(data.content);
      }
      if(lines.isEmpty && hasSubtitles){
        lines = await SutrasSubtitleUtils.getSutrasLines(data.subtitles);
      }
      //匹配中文
      final regExp = RegExp(r'[\u4e00-\u9fa5]');
      lines.forEachIndexed((row, element) {
        for (var i = 0; i < element.length; i++) {
          final text = element.substring(i, i+1);
          if (regExp.hasMatch(text)) {
            total++;
            items.add(TextItem(
              row: row,
              index: i,
              progress: total,
              text: text,
            ));
          }
        }
      });
      state = SutrasSubtitlesStatus.success;
    } catch (ex) {
      state = SutrasSubtitlesStatus.error;
      AppLogger.d(ex);
    }
  }

  ///下一个字符
  void next() {
    if (items.isEmpty) {
      // AppLogger.d('数据为空');
      return;
    }
    final item = textItem;
    if (item == null) {
      textItem = items.firstOrNull;
      return;
    }

    final prevItem = textItem;
    final index = items.indexOf(item) + 1;
    final currentItem = items.elementAtOrNull(index);
    if(currentItem == null){
      return;
    }
    textItem = currentItem;

    //滚动行
    if(currentItem.row != prevItem?.row && maxHeight > 0){
      final centerRow = maxHeight / SutrasSubtitlesView.itemExtent ~/ 2;
      if(currentItem.row >= centerRow){
        var count = 1;
        if(prevItem != null){
          count = currentItem.row - prevItem.row;
        }
        final maxScrollExtent = scrollController.position.maxScrollExtent;
        var offset = scrollController.offset + SutrasSubtitlesView.itemExtent * count;
        if(offset > maxScrollExtent){
          offset = maxScrollExtent;
        }
        scrollController.animateTo(offset, duration: 100.milliseconds, curve: Curves.linear);
      }
    }
  }
}

///经书加载状态
enum SutrasSubtitlesStatus {
  ///未加载
  idle,

  ///加载中
  loading,

  ///加载成功
  success,

  ///加载失败
  error,
}

///单个文字
class TextItem {
  ///第几行
  final int row;

  ///当前行的第几个字
  final int index;

  ///总字数的第几个字
  final int progress;

  ///文本
  final String text;

  TextItem({
    required this.row,
    required this.index,
    required this.progress,
    required this.text,
  });

  @override
  String toString() {
    return 'TextItem{row: $row, index: $index, progress: $progress, text: $text}';
  }
}

extension on String {
  (String?, String?, String?) splitWithIndex(int index) {
    String? left;
    String? center;
    String? right;
    if (isNotEmpty && index >= 0 && index <= length - 1) {
      if (index > 0) {
        left = substring(0, index);
      }
      center = substring(index, index + 1);
      if (index + 1 <= length - 1) {
        right = substring(index + 1);
      }
    }
    return (left, center, right);
  }
}

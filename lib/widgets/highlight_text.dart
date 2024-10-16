import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';

///高亮文本  例如：<highlight>高亮文本内容</highlight>
class HighlightText extends StatelessWidget {
  static const _startTag = r'<highlight>';
  static const _endTag = r'</highlight>';

  ///文本样式
  final TextStyle? style;

  ///高亮文本样式
  final TextStyle? highlightStyle;

  ///文本内容
  final String text;

  ///高亮文本配置
  final Map<String, HighlightedWord> words;

  const HighlightText(
    this.text, {
    super.key,
    this.style,
    this.highlightStyle,
    this.words = const {},
  });

  @override
  Widget build(BuildContext context) {
    final items = RegExp('(?<=$_startTag).+(?=$_endTag)').allMatches(text);
    if (items.isEmpty) {
      return Text(text, style: style);
    }

    final words = <String, HighlightedWord>{...this.words};
    for (var item in items) {
      final highlightText = '$_startTag${item.group(0)}$_endTag';
      words[highlightText] = HighlightedWord(textStyle: highlightStyle);
    }

    return TextHighlight(
      text: text,
      words: words,
      textStyle: style,
      highlightBuilder: (
        String fullText,
        String highlightText,
        TextStyle? highlightStyle,
      ) {
        return TextSpan(
          text: highlightText.replaceAll(_startTag, '').replaceAll(_endTag, ''),
          style: highlightStyle,
        );
      },
    );
  }
}

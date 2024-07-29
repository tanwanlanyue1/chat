// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:guanjia/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);



  });
}

String toLRC(String text){
  final sb = StringBuffer();
  var duration = Duration.zero;
  text.split('\n').forEach((element) {
    duration = duration + Duration(seconds: 3);
    final inMinutes = duration.inMinutes.toString().padLeft(2,'0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2,'0');
    sb.writeln('[$inMinutes:$seconds]$element');
  });
  return sb.toString();
}

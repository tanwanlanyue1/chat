import 'package:get/get.dart';
import 'package:lrc/lrc.dart';

class ChantSutrasPlayerState {

  final lrcRx = Rxn<Lrc>();
  final linesRx = <String>[].obs;
  final currentIndexRx = RxInt(-1);

}

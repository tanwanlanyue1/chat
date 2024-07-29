import 'package:logger/logger.dart';

///日志
class AppLogger{
  const AppLogger._();

  static final _logger = Logger(
    printer: PrettyPrinter(
      printEmojis: false,
      printTime: false,
      noBoxingByDefault: true,
      methodCount: 0,
    ),
    // output: TBLogOutput()
  );

  ///设置日志级别
  static set level(Level value) => Logger.level = value;

  ///Trace log
  static final t = _logger.t;

  ///Debug log
  static final d = _logger.d;

  ///Info log
  static final i = _logger.i;

  ///Warning log
  static final w = _logger.w;

  ///Error log
  static final e = _logger.e;

  ///What a fatal log
  static final f = _logger.f;

}

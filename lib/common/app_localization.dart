
import 'dart:ui';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/generated/l10n.dart';

///APP本地化设置
class AppLocalization{
  AppLocalization._();
  static final instance = AppLocalization._();

  final _preferences = LocalStorage('AppLocalization');
  static const _kLanguageCode = 'languageCode';
  ///默认中文语言
  static const _defaultLanguageCode = 'zh';

  ///当前使用的语言
  Locale? _locale;

  Future<void> initialize() async{
    var languageCode = await _preferences.getString(_kLanguageCode);
    languageCode ??= Get.deviceLocale?.languageCode ?? _defaultLanguageCode;
    _locale = supportedLocales.firstWhereOrNull((element) => element.languageCode == languageCode);
    _locale?.let(S.load);
  }

  ///支持的本地化语言
  List<Locale> get supportedLocales => S.delegate.supportedLocales;

  ///当前使用的语言
  Locale? get locale => _locale;

  ///更改使用的语言
  Future<void> updateLocale(Locale locale) async{
    if(_locale?.languageCode != locale.languageCode){
      _locale = locale;
      await _preferences.setString(_kLanguageCode, locale.languageCode);
      await Get.updateLocale(locale);
    }
  }

}
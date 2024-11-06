
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:guanjia/common/extension/functions_extension.dart';
import 'package:guanjia/common/utils/local_storage.dart';
import 'package:guanjia/generated/l10n.dart';

const kLanguageMap = {
  'zh-CN': _LanguageItem(0, '简体中文'),
  'zh-HK': _LanguageItem(1, '繁體中文'),
  'en': _LanguageItem(2, 'English'),
};

///APP本地化设置
class AppLocalization{
  AppLocalization._();
  static final instance = AppLocalization._();

  final _preferences = LocalStorage('AppLocalization');
  static const _kLanguageTag = 'languageTag';
  ///默认语言
  static const _defaultLanguageTag = 'en';

  ///当前使用的语言
  Locale? _locale;

  Future<void> initialize() async{
    var languageTag = await _preferences.getString(_kLanguageTag);
    languageTag ??= Get.deviceLocale?.toLanguageTag() ?? _defaultLanguageTag;
    _locale = supportedLocales.firstWhereOrNull((element) => element.toLanguageTag() == languageTag);
    _locale?.let(S.load);
  }

  ///支持的本地化语言
  List<Locale> get supportedLocales{
    return S.delegate.supportedLocales.sorted((a, b){
      return kLanguageMap[a.toLanguageTag()]?.index.compareTo(kLanguageMap[b.toLanguageTag()]?.index ?? 0) ?? 0;
    });
  }

  ///当前使用的语言
  Locale? get locale => _locale;

  ///更改使用的语言
  Future<void> updateLocale(Locale locale) async{
    if(_locale?.toLanguageTag() != locale.toLanguageTag()){
      _locale = locale;
      await _preferences.setString(_kLanguageTag, locale.toLanguageTag());
      await Get.updateLocale(locale);
    }
  }

}

extension LocaleX on Locale{

  ///语言名称
  String get languageName{
    return kLanguageMap[toLanguageTag()]?.name ?? '';
  }
}

class _LanguageItem{
  final int index;
  final String name;
  const _LanguageItem(this.index, this.name);
}
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:link_on/localization/language_localization.dart';

const String ENGLISH = "en";
const String SPANISH = "es";
const String ARABIC = "ar";
const String URDU = 'ur';
const String GERMAN = 'de';
const String FRENCH = 'fr';
const String CHINESE = 'zh';
const String DUTCH = 'nl';

String? translate(BuildContext context, String key) {
  return LanguageLocalization.of(context)!.translate(key);
}

Future<Locale> setLocale(String languageCode) async {
  setValue('current_language_code', languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case ENGLISH:
      _temp = Locale(languageCode, 'US');
      break;
    case SPANISH:
      _temp = Locale(languageCode, 'ES');
      break;
    case ARABIC:
      _temp = Locale(languageCode, 'AE');
      break;
    case URDU:
      _temp = Locale(languageCode, 'PK');
      break;
    case GERMAN:
      _temp = Locale(languageCode, 'DE');
      break;
    case FRENCH:
      _temp = Locale(languageCode, 'FR');
      break;
    case CHINESE:
      _temp = Locale(languageCode, 'CN');
      break;
    case DUTCH:
      _temp = Locale(languageCode, 'NL');
      break;
    default:
      _temp = Locale(ENGLISH, 'US');
  }
  return _temp;
}

Future<Locale> getLocale() async {
  String? languageCode = getStringAsync('current_language_code');
  return _locale(languageCode);
}

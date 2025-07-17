import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_on/localization/localization_constant.dart';

class LanguageLocalization {
  final Locale locale;

  LanguageLocalization(this.locale);

  static LanguageLocalization? of(BuildContext context) {
    return Localizations.of<LanguageLocalization>(
        context, LanguageLocalization);
  }

  static const LocalizationsDelegate<LanguageLocalization> delegate =
      _LangaugeLocalizationDelegate();

  late Map<String, String> _localizedStrings;

  Future load() async {
    String jsonString = await rootBundle.loadString(
        'lib/localization/languages/${locale.languageCode.toString()}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map(
      (key, value) => MapEntry(key, value),
    );
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }
}

class _LangaugeLocalizationDelegate
    extends LocalizationsDelegate<LanguageLocalization> {
  // List<Locale> _supportedLocales = [];

  const _LangaugeLocalizationDelegate();

  // Future<void> _loadSupportedLocales() async {
  //   _supportedLocales = await LanguageService.fetchAvailableLanguages();
  // }

  @override
  bool isSupported(Locale locale) {
    return [ENGLISH, SPANISH, ARABIC, URDU, GERMAN, FRENCH, CHINESE, DUTCH]
        .contains(locale.languageCode);
  }

  @override
  Future<LanguageLocalization> load(Locale locale) async {
    LanguageLocalization localization = LanguageLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<LanguageLocalization> old) =>
      false;
}

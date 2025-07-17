import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LanguageService {
  static Future<List<Locale>> fetchAvailableLanguages() async {
    final response =
        await http.get(Uri.parse('https://yourbackend.com/api/languages'));

    if (response.statusCode == 200) {
      List<LanguageModel> languages = json.decode(response.body);
      return languages
          .map((lang) => Locale(lang.languageCode, lang.countryCode))
          .toList();
    } else {
      throw Exception('Failed to load languages');
    }
  }
}

class LanguageModel {
  final String languageCode;
  final String countryCode;

  LanguageModel({required this.languageCode, required this.countryCode});
}

import 'dart:convert';
import 'dart:developer';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart';

class APIs {
  //get answer from google gemini ai
  static Future<String> getAnswer({required String question}) async {
    String apiKey = 'AIzaSyCHGIER2J6fAAcwM8k-pm5sCk7i9C0BLMA';

    try {
      log('api key: $apiKey');

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(question)];
      final res = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);

      log('res: ${res.text}');

      return res.text!;
    } catch (e) {
      log('getAnswerGeminiE: $e');
      return 'Something went wrong. Try again in sometime';
    }
  }

  // lexica generative ai
  static Future<List<String>> searchAiImages({required String prompt}) async {
    try {
      final res =
          await get(Uri.parse('https://lexica.art/api/v1/search?q=$prompt'));

      log('ai images : ${res.body}');

      final data = jsonDecode(res.body);

      log("ai images : $data");
      return List.from(data['images']).map((e) => e['src'].toString()).toList();
    } catch (e) {
      log('searchAiImagesE: $e');
      return [];
    }
  }

  //get answer from chat gpt
  // static Future<String> getAnswer(String question) async {
  //   String apiKey = 'sk-proj-e2LR5ViqQWCN2k9yd088T3BlbkFJrKwoRKlF9xB6wzpBBaj3';
  //   // String apiKey = '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';
  //   try {
  //     log('api key: $apiKey');

  //     final res =
  //         await post(Uri.parse('https://api.openai.com/v1/chat/completions'),
  //             headers: {
  //               HttpHeaders.contentTypeHeader: 'application/json',
  //               HttpHeaders.authorizationHeader: 'Bearer $apiKey'
  //             },
  //             body: jsonEncode({
  //               "model": "gpt-3.5-turbo",
  //               "max_tokens": 2000,
  //               "temperature": 0,
  //               "messages": [
  //                 {"role": "user", "content": question},
  //               ]
  //             }));

  //     final data = jsonDecode(res.body);

  //     log('res: $data');
  //     return data['choices'][0]['message']['content'];
  //   } catch (e) {
  //     log('getAnswerGptE: $e');
  //     return 'Something went wrong (Try again in sometime)';
  //   }
  // }
}

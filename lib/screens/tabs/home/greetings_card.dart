import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:link_on/controllers/postProvider/post_providermain.dart';
import 'package:link_on/localization/localization_constant.dart';

final List<String> morningMessages = [
  "morning_message_1",
  "morning_message_2",
  "morning_message_3",
];
final List<String> afternoonMessages = [
  "afternoon_message_1",
  "afternoon_message_2",
  "afternoon_message_3"
];
final List<String> eveningMessages = [
  "evening_message_1",
  "evening_message_2",
  "evening_message_3"
];
final List<String> nightMessages = [
  "night_message_1",
  "night_message_2",
  "night_message_3",
];

String getRandomElement(List<String> list) {
  final random = Random();
  int i = random.nextInt(list.length);
  return list[i];
}

Map<String, dynamic> getGreetingAndMessage() {
  int hour = DateTime.now().hour; // Calculate once
  String greeting;
  String message;
  IconData icon;
  Color color;
  // Simplify conditions
  if (hour >= 5 && hour < 12) {
    greeting = 'greeting_1';
    message = getRandomElement(morningMessages);

    icon = Icons.wb_sunny_outlined;

    color = const Color(0xffFFC107);
  } else if (hour >= 12 && hour < 17) {
    greeting = 'greeting_2';
    message = getRandomElement(afternoonMessages);
    icon = Icons.wb_sunny_rounded;
    color = const Color(0xffFF5733);
  } else if (hour >= 17 && hour < 21) {
    greeting = 'greeting_3';
    message = getRandomElement(eveningMessages);
    icon = Icons.nightlight_rounded;
    color = const Color(0xff9370DB);
  } else {
    greeting = 'greeting_4';
    message = getRandomElement(nightMessages);
    icon = Icons.nights_stay_rounded;
    color = const Color(0xff000000);
  }
  return {
    'greeting': greeting,
    'message': message,
    'icon': icon,
    'color': color
  };
}

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> greetingData = getGreetingAndMessage();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 50,
            ),
            Icon(
              greetingData['icon']!,
              color: greetingData['color']!,
              size: 28,
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Provider.of<GreetingsProvider>(context, listen: false)
                    .closeGreetingCard();
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Column(
          children: [
            Text(
              '${translate(context, greetingData['greeting'])}, ${getStringAsync('user_first_name')}!',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .95,
              child: Text(
                translate(context, greetingData['message']!).toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          color: Theme.of(context).colorScheme.secondary,
          height: 8,
        )
      ],
    );
  }
}

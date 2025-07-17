import 'package:flutter/material.dart';
import 'package:link_on/consts/colors.dart';
import 'package:link_on/controllers/moviesProvider/movie_provider.dart';
import 'package:link_on/localization/localization_constant.dart';
import 'package:link_on/screens/auth/login/login.page.dart';
import 'package:link_on/utils/slide_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  List<String> onBoardingAnimations = [
    'assets/anim/generative-ai.json',
    'assets/anim/crypto-wallet.json',
    'assets/anim/ai-chatbot.json',
  ];

  List<String> onBoardingText = [
    'generative_ai',
    'crypto_payments',
    'ai_chatbot',
  ];

  List<String> onBoardingDescription = [
    'generative_ai_description',
    'crypto_payments_description',
    'ai_chatbot_description',
  ];

  @override
  void initState() {
    setValue('isOnBoardingShown', true);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(createRoute(LoginPage()));
              },
              child: Text(translate(context, 'skip')!,
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
      floatingActionButton: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            fixedSize: const Size(120, 40)),
        onPressed: () {
          if (_pageController.page!.round() < onBoardingAnimations.length - 1) {
            _pageController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut);
          } else {
            Navigator.of(context).pushReplacement(createRoute(LoginPage()));
          }
        },
        child: Text(translate(context, 'next')!,
            style: const TextStyle(color: Colors.white)),
      ),
      body: Consumer<MoviesProvider>(
        builder: (context, providerValue, child) => Container(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  providerValue.changeOnBoardingIndex(value);
                },
                itemCount: onBoardingAnimations.length,
                itemBuilder: (_, index) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.5,
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: Lottie.asset(onBoardingAnimations[index])),
                        Text(
                          translate(context, onBoardingText[index])!,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            translate(context, onBoardingDescription[index])!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.2,
                        )
                      ],
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(onBoardingAnimations.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(microseconds: 1000),
                    width: providerValue.onBoardingCurrentIndex == index
                        ? 30.0
                        : 12.0,
                    height: 10.0,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: providerValue.onBoardingCurrentIndex == index
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withOpacity(0.7),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

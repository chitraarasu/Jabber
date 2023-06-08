import 'package:chatting_application/screens/onboarding/phone_number_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../widget/button_widget.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Colors.deepOrange, Colors.deepOrangeAccent],
        ),
      ),
      child: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Secure Chat',
              body:
                  'Privacy-focused messaging with end-to-end encryption for secure and confidential conversations',
              image: buildImage('assets/animations/chatting.json'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'End-To-End Encryption',
              body:
                  'Protecting your messages with unbreakable encryption, ensuring only the intended recipients can read them.',
              image: buildImage('assets/animations/encryption.json'),
              decoration: getPageDecoration(),
            ),
            // PageViewModel(
            //   title: 'Secure Chat',
            //   body:
            //       'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.',
            //   image: buildImage('assets/animations/security.json'),
            //   decoration: getPageDecoration(),
            // ),
            // PageViewModel(
            //   title: 'Music',
            //   body:
            //       'Music touches us emotionally, where words alone can’t. Listen to your favourite songs in just a tap.',
            //   image: buildImage('assets/animations/music.json'),
            //   decoration: getPageDecoration(),
            // ),
            // PageViewModel(
            //   title: 'News',
            //   body: 'Find the top news around you in simple terms.',
            //   image: buildImage('assets/animations/news.json'),
            //   decoration: getPageDecoration(),
            // ),
            // PageViewModel(
            //   title: 'Chat bot',
            //   body:
            //       'Keep in touch, manage tasks and to-dos, get answers, control your phone.',
            //   image: buildImage('assets/animations/robot-bot-3d.json'),
            //   decoration: getPageDecoration(),
            // ),
          ],
          done: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                "Next",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          onDone: () => goToPhoneNumberScreen(context),
          showSkipButton: true,
          skip: const Text('Skip'),
          onSkip: () => goToPhoneNumberScreen(context),
          skipStyle: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
            Colors.white,
          )),
          next: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.deepOrange,
              ),
            ),
          ),
          dotsDecorator: getDotDecoration(),
          globalBackgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  void goToPhoneNumberScreen(context) => Get.to(
        () => const PhoneNumberAndOtp(),
        transition: Transition.rightToLeftWithFade,
      );

  Widget buildImage(String path) {
    return Center(
      child: Lottie.asset(path, width: 350),
    );
  }

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Colors.white70,
        activeColor: Colors.white,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyTextStyle: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        footerPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
      );
}

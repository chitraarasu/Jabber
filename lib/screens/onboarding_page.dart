import 'package:chatting_application/screens/phone_number_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../widget/button_widget.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Lorem Ipsum',
            body:
                'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.',
            image: buildImage('assets/animations/chatting.json'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Secure Chat',
            body:
                'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.',
            image: buildImage('assets/animations/security.json'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Share it',
            body:
                'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.',
            image: buildImage('assets/animations/share.json'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Chat bot',
            body:
                'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.',
            footer: ButtonWidget(
              text: 'Start Reading',
              onClicked: () => goToPhoneNumberScreen(context),
            ),
            image: buildImage('assets/animations/robot-bot-3d.json'),
            decoration: getPageDecoration(),
          ),
        ],
        done: const Text('Next', style: TextStyle(fontWeight: FontWeight.w600)),
        onDone: () => goToPhoneNumberScreen(context),
        showSkipButton: true,
        skip: const Text('Skip'),
        onSkip: () => goToPhoneNumberScreen(context),
        next: const Icon(Icons.arrow_forward),
        dotsDecorator: getDotDecoration(),
        globalBackgroundColor: const Color(0xFFd6e2ea),
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
        color: const Color(0xFFBDBDBD),
        //activeColor: Colors.orange,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle:
            const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: const TextStyle(fontSize: 20),
        footerPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
      );
}

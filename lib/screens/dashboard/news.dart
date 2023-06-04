import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class News extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/animations/comming_soon.json"),
      ),
    );
  }
}

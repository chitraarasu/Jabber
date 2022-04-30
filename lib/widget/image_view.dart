import 'package:flutter/material.dart';

class CustomImageView extends StatelessWidget {
  const CustomImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Icon(Icons.close_rounded),
      ),
    );
  }
}

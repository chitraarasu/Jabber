import 'package:flutter/material.dart';

class PhoneNumber extends StatelessWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
              Column(
                children: const [
                  Text(""),
                  Text(""),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

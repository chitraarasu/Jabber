import 'package:flutter/material.dart';

class PhoneNumber extends StatelessWidget {
  const PhoneNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: const [
                      Text("Step 01/03", style: TextStyle(
                        fontSize: 15,
                      ),),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Your Phone Number", style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),),SizedBox(
                        height: 10,
                      ),
                      Text("We'll send you a code to your phone number", style: TextStyle(
                        fontSize: 15,
                      ),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  Function onTap;
  final condition;
  final icon;
  final name;

  CustomMaterialButton(this.onTap, this.condition, this.icon, this.name);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: condition ? const Color(0xFF006aff) : Colors.grey,
          ),
          Text(
            name,
            style: TextStyle(
              color: condition ? const Color(0xFF006aff) : Colors.grey,
              fontWeight: condition ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final title;
  final icon;
  final isSelected;
  Function onTap;

  CustomChip(this.title, this.icon, this.isSelected, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
              width: isSelected ? 2 : 0,
              color: isSelected ? const Color(0xFF006aff) : Colors.grey,
            ),
          ),
          margin: const EdgeInsets.all(5.0),
          child: Padding(
            padding: const EdgeInsets.all(12.5),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? const Color(0xFF006aff) : Colors.grey,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF006aff) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

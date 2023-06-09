import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  Function(String) onChange;
  final controller;

  Search(this.onChange, this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFebebec),
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      child: Container(
        height: 45.0,
        margin: const EdgeInsets.only(left: 5.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                // onTapOutside: (event) {
                //   FocusManager.instance.primaryFocus?.unfocus();
                // },
                controller: controller,
                maxLines: 1,
                onChanged: onChange,
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Color(0xFF86898f)),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF86898f),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

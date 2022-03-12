import 'package:flutter/material.dart';

class Search extends StatelessWidget {
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
        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Expanded(
              child: TextField(
                maxLines: 1,
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

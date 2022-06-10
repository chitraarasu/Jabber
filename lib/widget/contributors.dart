import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Contributors extends StatelessWidget {
  getContributors() async {
    var response = await http.get(
      Uri.parse(
          'https://api.github.com/repos/chitraarasu/chatting_application_flutter/contributors'),
      headers: {
        'Authorization': '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',
      },
    );
    var decodedResponse = json.decode(response.body);
    return decodedResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Contributors",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: FutureBuilder(
        future: getContributors(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            print(snapshot.data);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(snapshot.data[index]['html_url']));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  snapshot.data[index]['avatar_url'] != null
                                      ? NetworkImage(
                                          snapshot.data[index]['avatar_url'])
                                      : null,
                            ),
                            Text(
                              snapshot.data[index]['login'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Text("Check your internet connection"),
            );
          }
        },
      ),
    );
  }
}

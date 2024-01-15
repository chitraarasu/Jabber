import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:workmanager/workmanager.dart';

import 'controller/binder.dart';
import 'firebase_options.dart';
import 'screens/dashboard/home.dart';
import 'screens/onboarding/onboarding_page.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return Future.value(false);
    } else {
      await Firebase.initializeApp();
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(inputData!['currentUserId'])
          .get();

      // HomeController homeController = Get.find();
      for (var item = 0; item < inputData['messages'].length; item++) {
        var randomDoc = FirebaseFirestore.instance
            .collection("messages")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('channelChat')
            .doc();

        FirebaseFirestore.instance
            .collection('messages')
            .doc(inputData['cid'])
            .collection("channelChat")
            .doc(randomDoc.id)
            .set({
          'messageId': randomDoc.id,
          'message': inputData['messages'][item],
          'messageType': inputData['type'][item],
          'createdTime': Timestamp.now(),
          'senderId': inputData['currentUserId'],
          'senderName': userData['username'],
          'taggedMessageId': '',
        });
        FirebaseFirestore.instance
            .collection('messages')
            .doc(inputData['cid'])
            .update({
          'recentMessage': inputData['messages'][item],
          'time': Timestamp.now(),
        });
        // FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(inputData['currentUserId'])
        //     .collection("userChannels")
        //     .doc(inputData['cid'])
        //     .update({
        //   'recentMessage': inputData['messages'][item],
        //   'time': Timestamp.now(),
        // });

        // // Notification
        // FirebaseFirestore.instance
        //     .collection('messages')
        //     .doc(inputData['cid'])
        //     .collection("channelMembers")
        //     .get()
        //     .then((value) {
        //   var channelMembers = [];
        //   for (var item in value.docs) {
        //     channelMembers.add(item.data()["userId"]);
        //   }
        //   FirebaseFirestore.instance
        //       .collection('users')
        //       .get()
        //       .then((usersData) {
        //     var userTokens = [];
        //     for (var item in usersData.docs) {
        //       if (channelMembers.contains(item.data()["uid"])) {
        //         userTokens.add(item.data()["token"]);
        //       }
        //     }
        //     // homeController.sendNotification(
        //     //   data: {},
        //     //   tokens: userTokens,
        //     //   name: userData['username'],
        //     //   message: inputData['messages'][item],
        //     // );
        //   });
        // });
      }
      return Future.value(true);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) {
      print("Token -> $value");
    }).onError((error, stackTrace) {
      print(error);
    });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   var notification = message.data;
    //   print(notification);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('notification');
    //   var notification = message.data;
    //   print(notification);
    // });
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Jabber",
      initialBinding: Binder(),
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _auth.currentUser == null ? const OnBoardingPage() : const Home(),
    );
  }
}

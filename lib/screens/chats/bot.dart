// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:sound_stream/sound_stream.dart';
// import 'package:dialogflow_grpc/dialogflow_grpc.dart';
// import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
//
// var dialogflow;
// var _profileLink;
//
// class Chat extends StatefulWidget {
//   @override
//   _ChatState createState() => _ChatState();
// }
//
// class _ChatState extends State<Chat> {
//   final List<ChatMessage> _messages = <ChatMessage>[];
//   final TextEditingController _textController = TextEditingController();
//
//   late Stream profileStream;
//
//   bool _isRecording = false;
//
//   RecorderStream _recorder = RecorderStream();
//   var _recorderStatus;
//   var _audioStreamSubscription;
//   var _audioStream;
//
//   @override
//   void initState() {
//     super.initState();
//     stopStream();
//     initPlugin();
//     profileStream = FirebaseFirestore.instance
//         .collection("users")
//         .doc(FirebaseAuth.instance.currentUser?.uid)
//         .snapshots();
//   }
//
//   @override
//   void dispose() {
//     stopStream();
//     _recorderStatus?.cancel();
//     _audioStreamSubscription?.cancel();
//     super.dispose();
//   }
//
//   Future<void> initPlugin() async {
//     _recorderStatus = _recorder.status.listen((status) {
//       if (mounted)
//         setState(() {
//           _isRecording = status == SoundStreamStatus.Playing;
//         });
//     });
//
//     await Future.wait([_recorder.initialize()]);
//     final serviceAccount = ServiceAccount.fromString(
//         '${(await rootBundle.loadString('assets/credentials.json'))}');
//     dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
//   }
//
//   void stopStream() async {
//     await _recorder.stop();
//     await _audioStreamSubscription?.cancel();
//     await _audioStream?.close();
//   }
//
//   void handleSubmitted(text) async {
//     print(text);
//     _textController.clear();
//
//     ChatMessage message = ChatMessage(
//       text: text,
//       name: "You",
//       type: true,
//     );
//
//     setState(() {
//       _messages.insert(0, message);
//     });
//
//     DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');
//     String fulfillmentText = data.queryResult.fulfillmentText;
//     if (fulfillmentText.isNotEmpty) {
//       ChatMessage botMessage = ChatMessage(
//         text: fulfillmentText,
//         name: "Bot",
//         type: false,
//       );
//
//       setState(() {
//         _messages.insert(0, botMessage);
//       });
//     }
//   }
//
//   void handleStream() async {
//     _recorder.start();
//
//     _audioStream = BehaviorSubject<List<int>>();
//     _audioStreamSubscription = _recorder.audioStream.listen((data) {
//       print(data);
//       _audioStream.add(data);
//     });
//
//     var biasList = SpeechContextV2Beta1(phrases: [
//       'Dialogflow CX',
//       'Dialogflow Essentials',
//       'Action Builder',
//       'HIPAA'
//     ], boost: 20.0);
//
//     var config = InputConfigV2beta1(
//         encoding: 'AUDIO_ENCODING_LINEAR_16',
//         languageCode: 'en-US',
//         sampleRateHertz: 16000,
//         singleUtterance: false,
//         speechContexts: [biasList]);
//
//     final responseStream =
//         dialogflow.streamingDetectIntent(config, _audioStream);
//     responseStream.listen((data) {
//       setState(() {
//         String transcript = data.recognitionResult.transcript;
//         String queryText = data.queryResult.queryText;
//         String fulfillmentText = data.queryResult.fulfillmentText;
//
//         if (fulfillmentText.isNotEmpty) {
//           ChatMessage message = ChatMessage(
//             text: queryText,
//             name: "You",
//             type: true,
//           );
//
//           ChatMessage botMessage = ChatMessage(
//             text: fulfillmentText,
//             name: "Bot",
//             type: false,
//           );
//
//           _messages.insert(0, message);
//           _textController.clear();
//           _messages.insert(0, botMessage);
//         }
//         if (transcript.isNotEmpty) {
//           _textController.text = transcript;
//         }
//       });
//     }, onError: (e) {
//       //print(e);
//     }, onDone: () {
//       //print('done');
//     });
//   }
//
//   // The chat interface
//   //
//   //------------------------------------------------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         toolbarHeight: 70,
//         backgroundColor: Colors.white,
//         titleSpacing: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_rounded,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         title: Row(
//           children: [
//             const Expanded(
//               child: Text(
//                 'Bot',
//                 style: TextStyle(
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 20.0),
//               child: Lottie.asset(
//                 'assets/animations/bot-icon.json',
//                 width: 45,
//               ),
//             ),
//           ],
//         ),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(30),
//           ),
//         ),
//       ),
//       body: Column(children: <Widget>[
//         StreamBuilder(
//             stream: profileStream,
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Expanded(
//                   child: SpinKitFadingCircle(
//                     color: Color(0xFF006aff),
//                     size: 45.0,
//                     duration: Duration(milliseconds: 1000),
//                   ),
//                 );
//               } else {
//                 var docs = snapshot.data;
//                 _profileLink = docs.get('profileUrl');
//                 return Expanded(
//                   child: _messages.isEmpty
//                       ? Center(
//                           child: GestureDetector(
//                             onTap: () {
//                               handleSubmitted("Hi!");
//                             },
//                             child: Lottie.asset(
//                                 "assets/animations/robot-says-hello.json"),
//                           ),
//                         )
//                       : ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           padding: EdgeInsets.all(8.0),
//                           reverse: true,
//                           itemBuilder: (_, int index) => _messages[index],
//                           itemCount: _messages.length,
//                         ),
//                 );
//               }
//             }),
//         Container(
//           color: Colors.white,
//           child: Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFf7f7f7),
//                       border: Border.all(
//                         width: 1,
//                         color: Colors.grey,
//                       ),
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(25.0),
//                       ),
//                     ),
//                     child: SizedBox(
//                       height: 45.0,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           Expanded(
//                             child: TextField(
//                               textCapitalization: TextCapitalization.sentences,
//                               controller: _textController,
//                               onSubmitted: handleSubmitted,
//                               minLines: 1,
//                               maxLines: 5,
//                               keyboardType: TextInputType.multiline, //
//                               textInputAction: TextInputAction.newline,
//                               decoration: const InputDecoration(
//                                 hintText: "Type your message here",
//                                 hintStyle: TextStyle(color: Colors.grey),
//                                 border: InputBorder.none,
//                               ),
//                             ),
//                           ),
//                           if (_isRecording)
//                             GestureDetector(
//                               onTap: _isRecording ? stopStream : handleStream,
//                               child: Container(
//                                 child: Lottie.asset(
//                                   "assets/animations/stop-recording.json",
//                                 ),
//                               ),
//                             )
//                           else
//                             FloatingActionButton.small(
//                               heroTag: const Text("btn2"),
//                               elevation: 0,
//                               disabledElevation: 0,
//                               hoverElevation: 0,
//                               highlightElevation: 0,
//                               focusElevation: 0,
//                               onPressed:
//                                   _isRecording ? stopStream : handleStream,
//                               backgroundColor: Colors.transparent,
//                               child: Icon(
//                                 _isRecording ? Icons.stop : Icons.mic,
//                                 color: Colors.grey,
//                                 size: 20,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               FloatingActionButton.small(
//                 heroTag: const Text("btn3"),
//                 elevation: 0,
//                 disabledElevation: 0,
//                 hoverElevation: 0,
//                 highlightElevation: 0,
//                 focusElevation: 0,
//                 onPressed: () async {
//                   if (_textController.text.isEmpty) {
//                     return;
//                   }
//                   handleSubmitted(_textController.text);
//                   stopStream();
//                 },
//                 backgroundColor: Colors.deepOrange,
//                 child: const Icon(
//                   Icons.send_rounded,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
// }
//
// //------------------------------------------------------------------------------------
// // The chat message balloon
// //
// //------------------------------------------------------------------------------------
// class ChatMessage extends StatelessWidget {
//   ChatMessage({this.text, this.name, this.type});
//
//   final text;
//   final name;
//   final type;
//
//   List<Widget> otherMessage(context) {
//     return <Widget>[
//       Container(
//         margin: const EdgeInsets.only(right: 16.0),
//         child: CircleAvatar(
//           backgroundColor: Colors.transparent,
//           backgroundImage: AssetImage("assets/images/bot-icon.png"),
//         ),
//       ),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//             Container(
//               margin: const EdgeInsets.only(top: 5.0),
//               child: Text(text),
//             ),
//           ],
//         ),
//       ),
//     ];
//   }
//
//   List<Widget> myMessage(context) {
//     return <Widget>[
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             Text(name, style: Theme.of(context).textTheme.subtitle1),
//             Container(
//               margin: const EdgeInsets.only(top: 5.0),
//               child: Text(text),
//             ),
//           ],
//         ),
//       ),
//       Container(
//         margin: const EdgeInsets.only(left: 16.0),
//         child: CircleAvatar(
//           child: Center(
//             child: Text(
//               "Y",
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           backgroundImage:
//               _profileLink == null ? null : NetworkImage(_profileLink),
//         ),
//       ),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: type ? myMessage(context) : otherMessage(context),
//       ),
//     );
//   }
// }

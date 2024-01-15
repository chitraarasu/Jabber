

// class Jitsi extends StatefulWidget {
//   final currentCall;
//
//   Jitsi(this.currentCall);
//
//   @override
//   State<Jitsi> createState() => _JitsiState();
// }
//
// class _JitsiState extends State<Jitsi> {
//   bool audioMuted = true;
//   bool videoMuted = true;
//   bool screenShareOn = false;
//
//   @override
//   void dispose() {
//     super.dispose();
//     if (widget.currentCall != null)
//       FlutterCallkitIncoming.endCall(widget.currentCall!.id!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Plugin example app'),
//           ),
//           body: Center(
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   // TextButton(
//                   //   onPressed: join,
//                   //   child: const Text("Join"),
//                   // ),
//                   TextButton(onPressed: hangUp, child: const Text("Hang Up")),
//                   Row(children: [
//                     const Text("Set Audio Muted"),
//                     Checkbox(
//                       value: audioMuted,
//                       onChanged: setAudioMuted,
//                     ),
//                   ]),
//                   Row(children: [
//                     const Text("Set Video Muted"),
//                     Checkbox(
//                       value: videoMuted,
//                       onChanged: setVideoMuted,
//                     ),
//                   ]),
//                   TextButton(
//                       onPressed: sendEndpointTextMessage,
//                       child: const Text("Send Hey Endpoint Message To All")),
//                   Row(children: [
//                     const Text("Toggle Screen Share"),
//                     Checkbox(
//                       value: screenShareOn,
//                       onChanged: toggleScreenShare,
//                     ),
//                   ]),
//                   TextButton(
//                       onPressed: openC hat, child: const Text("Open Chat")),
//                   TextButton(
//                       onPressed: sendChatMessage,
//                       child: const Text("Send Chat Message to All")),
//                   TextButton(
//                       onPressed: closeChat, child: const Text("Close Chat")),
//                   TextButton(
//                       onPressed: retrieveParticipantsInfo,
//                       child: const Text("Retrieve Participants Info")),
//                 ]),
//           )),
//     );
//   }
// }

import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class CallController extends GetxController {
  final _jitsiMeetPlugin = JitsiMeet();
  List<String> participants = [];

  join(roomId) async {
    // var jwtToken = await FirebaseAuth.instance.currentUser?.getIdToken() ?? "";
    // print("ladkfmnlkdsc");
    // print(jwtToken);
    // var options = JitsiMeetConferenceOptions(
    //   room: roomId,
    //   configOverrides: {
    //     "startWithAudioMuted": false,
    //     "startWithVideoMuted": false,
    //     "subject": "Lipitori"
    //   },
    //   featureFlags: {
    //     "unsaferoomwarning.enabled": false,
    //     "ios.screensharing.enabled": true
    //   },
    //   token: jwtToken,
    //   // userInfo: JitsiMeetUserInfo(
    //   //     displayName: "Gabi",
    //   //     email: "gabi.borlea.1@gmail.com",
    //   //     avatar:
    //   //         "https://avatars.githubusercontent.com/u/57035818?s=400&u=02572f10fe61bca6fc20426548f3920d53f79693&v=4"),
    // );
    //
    // var listener = JitsiMeetEventListener(
    //   conferenceJoined: (url) {
    //     debugPrint("conferenceJoined: url: $url");
    //   },
    //   conferenceTerminated: (url, error) {
    //     debugPrint("conferenceTerminated: url: $url, error: $error");
    //   },
    //   conferenceWillJoin: (url) {
    //     debugPrint("conferenceWillJoin: url: $url");
    //   },
    //   participantJoined: (email, name, role, participantId) {
    //     debugPrint(
    //       "participantJoined: email: $email, name: $name, role: $role, "
    //       "participantId: $participantId",
    //     );
    //     participants.add(participantId!);
    //   },
    //   participantLeft: (participantId) {
    //     debugPrint("participantLeft: participantId: $participantId");
    //   },
    //   audioMutedChanged: (muted) {
    //     debugPrint("audioMutedChanged: isMuted: $muted");
    //   },
    //   videoMutedChanged: (muted) {
    //     debugPrint("videoMutedChanged: isMuted: $muted");
    //   },
    //   endpointTextMessageReceived: (senderId, message) {
    //     debugPrint(
    //         "endpointTextMessageReceived: senderId: $senderId, message: $message");
    //   },
    //   screenShareToggled: (participantId, sharing) {
    //     debugPrint(
    //       "screenShareToggled: participantId: $participantId, "
    //       "isSharing: $sharing",
    //     );
    //   },
    //   chatMessageReceived: (senderId, message, isPrivate, timestamp) {
    //     debugPrint(
    //       "chatMessageReceived: senderId: $senderId, message: $message, "
    //       "isPrivate: $isPrivate, timestamp: $timestamp",
    //     );
    //   },
    //   chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
    //   participantsInfoRetrieved: (participantsInfo) {
    //     debugPrint(
    //         "participantsInfoRetrieved: participantsInfo: $participantsInfo, ");
    //   },
    //   readyToClose: () {
    //     debugPrint("readyToClose");
    //   },
    // );
    // await _jitsiMeetPlugin.join(options, listener);
  }

  hangUp(currentCallId) async {
    await _jitsiMeetPlugin.hangUp();
    await makeEndCall(currentCallId);
    Get.back();

    // // new code of jitsi
    // if (currentCall != null) {
    //   await makeEndCall(widget.currentCall!.id!);
    //   // widget.currentCall = null;
    // }
    // Get.back();
    // await requestHttp('END_CALL');
  }

  // setAudioMuted(bool? muted) async {
  //   var a = await _jitsiMeetPlugin.setAudioMuted(muted!);
  //   debugPrint("$a");
  //   setState(() {
  //     audioMuted = muted;
  //   });
  // }
  //
  // setVideoMuted(bool? muted) async {
  //   var a = await _jitsiMeetPlugin.setVideoMuted(muted!);
  //   debugPrint("$a");
  //   setState(() {
  //     videoMuted = muted;
  //   });
  // }
  //
  // sendEndpointTextMessage() async {
  //   var a = await _jitsiMeetPlugin.sendEndpointTextMessage(message: "HEY");
  //   debugPrint("$a");
  //
  //   for (var p in participants) {
  //     var b =
  //         await _jitsiMeetPlugin.sendEndpointTextMessage(to: p, message: "HEY");
  //     debugPrint("$b");
  //   }
  // }
  //
  // toggleScreenShare(bool? enabled) async {
  //   await _jitsiMeetPlugin.toggleScreenShare(enabled!);
  //
  //   setState(() {
  //     screenShareOn = enabled;
  //   });
  // }
  //
  // openChat() async {
  //   await _jitsiMeetPlugin.openChat();
  // }
  //
  // sendChatMessage() async {
  //   var a = await _jitsiMeetPlugin.sendChatMessage(message: "HEY1");
  //   debugPrint("$a");
  //
  //   for (var p in participants) {
  //     a = await _jitsiMeetPlugin.sendChatMessage(to: p, message: "HEY2");
  //     debugPrint("$a");
  //   }
  // }
  //
  // closeChat() async {
  //   await _jitsiMeetPlugin.closeChat();
  // }
  //
  // retrieveParticipantsInfo() async {
  //   var a = await _jitsiMeetPlugin.retrieveParticipantsInfo();
  //   debugPrint("$a");
  // }

  // Calling file

  Future<void> makeFakeConnectedCall(id) async {
    await FlutterCallkitIncoming.setCallConnected(id);
  }

  Future<void> makeEndCall(id) async {
    await FlutterCallkitIncoming.endCall(id);
  }

// //check with https://webhook.site/#!/2748bc41-8599-4093-b8ad-93fd328f1cd2
// Future<void> requestHttp(content) async {
//   get(Uri.parse(
//       'https://webhook.site/2748bc41-8599-4093-b8ad-93fd328f1cd2?data=$content'));
// }
}

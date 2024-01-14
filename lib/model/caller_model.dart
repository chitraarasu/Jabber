// To parse this JSON data, do
//
//     final callModel = callModelFromJson(jsonString);

import 'dart:convert';

CallModel callModelFromJson(String str) => CallModel.fromJson(json.decode(str));

String callModelToJson(CallModel data) => json.encode(data.toJson());

class CallModel {
  final String? type;
  final String? nameCaller;
  final String? avatar;
  final String? number;

  CallModel({
    this.type,
    this.nameCaller,
    this.avatar,
    this.number,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
        type: json["type"],
        nameCaller: json["name_caller"],
        avatar: json["avatar"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "type": type ?? "",
        "name_caller": nameCaller ?? "",
        "avatar": avatar ?? "",
        "number": number ?? "",
      };
}

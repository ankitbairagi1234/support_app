// To parse this JSON data, do
//
//     final stateModel = stateModelFromJson(jsonString);

import 'dart:convert';

StateModel stateModelFromJson(String str) => StateModel.fromJson(json.decode(str));

String stateModelToJson(StateModel data) => json.encode(data.toJson());

class StateModel {
  int? status;
  String? message;
  List<GetState>? data;

  StateModel({
    this.status,
    this.message,
    this.data,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
    status: json["status"],
    message: json["message"],
    data: List<GetState>.from(json["data"].map((x) => GetState.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GetState {
  int? id;
  String? name;

  GetState({
    this.id,
    this.name,
  });

  factory GetState.fromJson(Map<String, dynamic> json) => GetState(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

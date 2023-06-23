// To parse this JSON data, do
//
//     final citiesModel = citiesModelFromJson(jsonString);

import 'dart:convert';

CitiesModel citiesModelFromJson(String str) => CitiesModel.fromJson(json.decode(str));

String citiesModelToJson(CitiesModel data) => json.encode(data.toJson());

class CitiesModel {
  int? status;
  String? message;
  List<GetCities>? data;

  CitiesModel({
    this.status,
    this.message,
    this.data,
  });

  factory CitiesModel.fromJson(Map<String, dynamic> json) => CitiesModel(
    status: json["status"],
    message: json["message"],
    data: List<GetCities>.from(json["data"].map((x) => GetCities.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GetCities {
  int? id;
  String? cityName;
  int? stateId;

  GetCities({
    this.id,
    this.cityName,
    this.stateId,
  });

  factory GetCities.fromJson(Map<String, dynamic> json) => GetCities(
    id: json["id"],
    cityName: json["city_name"],
    stateId: json["state_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_name": cityName,
    "state_id": stateId,
  };
}

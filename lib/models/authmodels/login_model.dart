// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  int? status;
  String? message;
  LoginData? data;

  LoginModel({
    this.status,
    this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    message: json["message"],
    data: LoginData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class LoginData {
  int? id;
  String? name;
  String? email;
  String? mobile;
  int? uType;
  dynamic picture;
  String? adharCard;
  String? dlLicense;
  String? elBill;
  String? address;
  String? city;
  String? state;
  bool? token;

  LoginData({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.uType,
    this.picture,
    this.adharCard,
    this.dlLicense,
    this.elBill,
    this.address,
    this.city,
    this.state,
    this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    uType: json["u_type"],
    picture: json["picture"],
    adharCard: json["adhar_card"],
    dlLicense: json["dl_license"],
    elBill: json["el_bill"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "u_type": uType,
    "picture": picture,
    "adhar_card": adharCard,
    "dl_license": dlLicense,
    "el_bill": elBill,
    "address": address,
    "city": city,
    "state": state,
    "token": token,
  };
}

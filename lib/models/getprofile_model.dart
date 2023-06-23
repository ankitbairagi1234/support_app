// To parse this JSON data, do
//
//     final getProfile = getProfileFromJson(jsonString);

import 'dart:convert';

GetProfile getProfileFromJson(String str) => GetProfile.fromJson(json.decode(str));

String getProfileToJson(GetProfile data) => json.encode(data.toJson());

class GetProfile {
  int? status;
  String? message;
  Data? data;

  GetProfile({
    this.status,
    this.message,
    this.data,
  });

  factory GetProfile.fromJson(Map<String, dynamic> json) => GetProfile(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? mobile;
  dynamic picture;
  dynamic adharCard;
  dynamic dlLicense;
  dynamic elBill;
  int? uType;
  dynamic address;
  dynamic city;
  dynamic state;
  dynamic createdAt;
  dynamic updatedAt;

  Data({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.mobile,
    this.picture,
    this.adharCard,
    this.dlLicense,
    this.elBill,
    this.uType,
    this.address,
    this.city,
    this.state,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    mobile: json["mobile"],
    picture: json["picture"],
    adharCard: json["adhar_card"],
    dlLicense: json["dl_license"],
    elBill: json["el_bill"],
    uType: json["u_type"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "mobile": mobile,
    "picture": picture,
    "adhar_card": adharCard,
    "dl_license": dlLicense,
    "el_bill": elBill,
    "u_type": uType,
    "address": address,
    "city": city,
    "state": state,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

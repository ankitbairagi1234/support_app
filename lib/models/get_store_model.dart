class GetStoreList {
  int? status;
  String? message;
  List<Data>? data;

  GetStoreList({this.status, this.message, this.data});

  GetStoreList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? storeName;
  String? storeAddress;
  String? city;
  String? state;
  String? country;
  Null? storeLat;
  Null? storeLong;
  int? pinCode;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.storeName,
        this.storeAddress,
        this.city,
        this.state,
        this.country,
        this.storeLat,
        this.storeLong,
        this.pinCode,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['store_name'];
    storeAddress = json['store_address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    storeLat = json['store_lat'];
    storeLong = json['store_long'];
    pinCode = json['pin_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_name'] = this.storeName;
    data['store_address'] = this.storeAddress;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['store_lat'] = this.storeLat;
    data['store_long'] = this.storeLong;
    data['pin_code'] = this.pinCode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
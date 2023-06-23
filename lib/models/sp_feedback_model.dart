class SpFeedBackModel {
  int? status;
  String? message;
  List<Data>? data;

  SpFeedBackModel({this.status, this.message, this.data});

  SpFeedBackModel.fromJson(Map<String, dynamic> json) {
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
  String? description;
  int? stars;
  String? name;
  String? email;
  String? picture;

  Data({this.description, this.stars, this.name, this.email, this.picture});

  Data.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    stars = json['stars'];
    name = json['name'];
    email = json['email'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['stars'] = this.stars;
    data['name'] = this.name;
    data['email'] = this.email;
    data['picture'] = this.picture;
    return data;
  }
}
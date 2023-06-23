class ResolveTicketModel {
  int? status;
  String? message;
  List<Data>? data;

  ResolveTicketModel({this.status, this.message, this.data});

  ResolveTicketModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  int? productId;
  String? ticket;
  String? image;
  String? description;
  String? address;
  String? city;
  String? state;
  int? status;
  int? otp;
  int? ticketType;
  int? changeStatusBy;
  int? adminRead;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.productId,
        this.ticket,
        this.image,
        this.description,
        this.address,
        this.city,
        this.state,
        this.status,
        this.otp,
        this.ticketType,
        this.changeStatusBy,
        this.adminRead,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    ticket = json['ticket'];
    image = json['image'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    status = json['status'];
    otp = json['otp'];
    ticketType = json['ticket_type'];
    changeStatusBy = json['change_status_by'];
    adminRead = json['admin_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['ticket'] = this.ticket;
    data['image'] = this.image;
    data['description'] = this.description;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['status'] = this.status;
    data['otp'] = this.otp;
    data['ticket_type'] = this.ticketType;
    data['change_status_by'] = this.changeStatusBy;
    data['admin_read'] = this.adminRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
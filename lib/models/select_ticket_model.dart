class SelectTicketModel {
  int? status;
  String? message;
  List<Data>? data;

  SelectTicketModel({this.status, this.message, this.data});

  SelectTicketModel.fromJson(Map<String, dynamic> json) {
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
  String? ticket;
  int? taskId;

  Data({this.id, this.ticket, this.taskId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticket = json['ticket'];
    taskId = json['taskId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket'] = this.ticket;
    data['taskId'] = this.taskId;
    return data;
  }
}
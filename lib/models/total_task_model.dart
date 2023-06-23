class TotalTask {
  int? status;
  String? message;
  List<Data>? data;

  TotalTask({this.status, this.message, this.data});

  TotalTask.fromJson(Map<String, dynamic> json) {
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
  int? taskId;
  int? taskStatus;
  int? ticketId;
  int? priorityType;
  String? ticket;
  int? ticketType;
  String? address;
  String? state;
  String? city;
  String? productName;
  Null? reasonsStatus;
  Null? reasonId;
  String? priorityStatus;
  String? tasksStatus;

  Data(
      {this.taskId,
        this.taskStatus,
        this.ticketId,
        this.priorityType,
        this.ticket,
        this.ticketType,
        this.address,
        this.state,
        this.city,
        this.productName,
        this.reasonsStatus,
        this.reasonId,
        this.priorityStatus,
        this.tasksStatus});

  Data.fromJson(Map<String, dynamic> json) {
    taskId = json['taskId'];
    taskStatus = json['task_status'];
    ticketId = json['ticketId'];
    priorityType = json['priority_type'];
    ticket = json['ticket'];
    ticketType = json['ticket_type'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
    productName = json['product_name'];
    reasonsStatus = json['reasons_status'];
    reasonId = json['reason_id'];
    priorityStatus = json['priority_status'];
    tasksStatus = json['tasks_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskId'] = this.taskId;
    data['task_status'] = this.taskStatus;
    data['ticketId'] = this.ticketId;
    data['priority_type'] = this.priorityType;
    data['ticket'] = this.ticket;
    data['ticket_type'] = this.ticketType;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['product_name'] = this.productName;
    data['reasons_status'] = this.reasonsStatus;
    data['reason_id'] = this.reasonId;
    data['priority_status'] = this.priorityStatus;
    data['tasks_status'] = this.tasksStatus;
    return data;
  }
}
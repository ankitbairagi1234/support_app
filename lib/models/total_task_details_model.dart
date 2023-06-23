class TotalTaskDetailsModel {
  int? status;
  String? message;
  Data? data;

  TotalTaskDetailsModel({this.status, this.message, this.data});

  TotalTaskDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? taskId;
  int? taskStatus;
  String? endTime;
  int? ticketId;
  String? taskDescription;
  int? priorityType;
  String? ticket;
  int? ticketType;
  String? image;
  String? description;
  String? address;
  String? state;
  String? city;
  int? ticketStatus;
  int? productId;
  String? name;
  String? mobile;
  String? productName;
  String? productImage;
  String? productInvoice;
  String? warrantyCard;
  String? purchasedDate;
  String? warrantyDate;
  String? invoiceDate;
  String? invoiceNo;

  Data(
      {this.taskId,
        this.taskStatus,
        this.endTime,
        this.ticketId,
        this.taskDescription,
        this.priorityType,
        this.ticket,
        this.ticketType,
        this.image,
        this.description,
        this.address,
        this.state,
        this.city,
        this.ticketStatus,
        this.productId,
        this.name,
        this.mobile,
        this.productName,
        this.productImage,
        this.productInvoice,
        this.warrantyCard,
        this.purchasedDate,
        this.warrantyDate,
        this.invoiceDate,
        this.invoiceNo});

  Data.fromJson(Map<String, dynamic> json) {
    taskId = json['taskId'];
    taskStatus = json['task_status'];
    endTime = json['end_time'];
    ticketId = json['ticketId'];
    taskDescription = json['task_description'];
    priorityType = json['priority_type'];
    ticket = json['ticket'];
    ticketType = json['ticket_type'];
    image = json['image'];
    description = json['description'];
    address = json['address'];
    state = json['state'];
    city = json['city'];
    ticketStatus = json['ticketStatus'];
    productId = json['product_id'];
    name = json['name'];
    mobile = json['mobile'];
    productName = json['product_name'];
    productImage = json['product_image'];
    productInvoice = json['product_invoice'];
    warrantyCard = json['warranty_card'];
    purchasedDate = json['purchased_date'];
    warrantyDate = json['warranty_date'];
    invoiceDate = json['invoice_date'];
    invoiceNo = json['invoice_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskId'] = this.taskId;
    data['task_status'] = this.taskStatus;
    data['end_time'] = this.endTime;
    data['ticketId'] = this.ticketId;
    data['task_description'] = this.taskDescription;
    data['priority_type'] = this.priorityType;
    data['ticket'] = this.ticket;
    data['ticket_type'] = this.ticketType;
    data['image'] = this.image;
    data['description'] = this.description;
    data['address'] = this.address;
    data['state'] = this.state;
    data['city'] = this.city;
    data['ticketStatus'] = this.ticketStatus;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['product_invoice'] = this.productInvoice;
    data['warranty_card'] = this.warrantyCard;
    data['purchased_date'] = this.purchasedDate;
    data['warranty_date'] = this.warrantyDate;
    data['invoice_date'] = this.invoiceDate;
    data['invoice_no'] = this.invoiceNo;
    return data;
  }
}
class AllTicketDetailsModel {
  int? status;
  String? message;
  Data? data;

  AllTicketDetailsModel({this.status, this.message, this.data});

  AllTicketDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  int? ticketType;
  int? productId;
  int? status;
  int? ticketId;
  String? ticket;
  String? image;
  String? description;
  String? address;
  String? city;
  String? state;
  int? id;
  String? productName;
  String? productImage;
  String? warrantyCard;
  String? productInvoice;
  String? purchasedDate;
  String? invoiceDate;
  String? warrantyDate;
  String? reasonsTitle;
  String? reasonsDescription;
  String? reasonsImage;
  int? technicianId;
  String? proStatus;
  String? serviceStatus;

  Data(
      {this.createdAt,
        this.ticketType,
        this.productId,
        this.status,
        this.ticketId,
        this.ticket,
        this.image,
        this.description,
        this.address,
        this.city,
        this.state,
        this.id,
        this.productName,
        this.productImage,
        this.warrantyCard,
        this.productInvoice,
        this.purchasedDate,
        this.invoiceDate,
        this.warrantyDate,
        this.reasonsTitle,
        this.reasonsDescription,
        this.reasonsImage,
        this.technicianId,
        this.proStatus,
        this.serviceStatus});

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    ticketType = json['ticket_type'];
    productId = json['product_id'];
    status = json['status'];
    ticketId = json['ticketId'];
    ticket = json['ticket'];
    image = json['image'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    id = json['id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    warrantyCard = json['warranty_card'];
    productInvoice = json['product_invoice'];
    purchasedDate = json['purchased_date'];
    invoiceDate = json['invoice_date'];
    warrantyDate = json['warranty_date'];
    reasonsTitle = json['reasons_title'];
    reasonsDescription = json['reasons_description'];
    reasonsImage = json['reasons_image'];
    technicianId = json['technician_id'];
    proStatus = json['pro_status'];
    serviceStatus = json['service_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['ticket_type'] = this.ticketType;
    data['product_id'] = this.productId;
    data['status'] = this.status;
    data['ticketId'] = this.ticketId;
    data['ticket'] = this.ticket;
    data['image'] = this.image;
    data['description'] = this.description;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['warranty_card'] = this.warrantyCard;
    data['product_invoice'] = this.productInvoice;
    data['purchased_date'] = this.purchasedDate;
    data['invoice_date'] = this.invoiceDate;
    data['warranty_date'] = this.warrantyDate;
    data['reasons_title'] = this.reasonsTitle;
    data['reasons_description'] = this.reasonsDescription;
    data['reasons_image'] = this.reasonsImage;
    data['technician_id'] = this.technicianId;
    data['pro_status'] = this.proStatus;
    data['service_status'] = this.serviceStatus;
    return data;
  }
}
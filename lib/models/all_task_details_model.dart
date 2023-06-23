class AllTaskDetails {
  int? status;
  String? message;
  Data? data;

  AllTaskDetails({this.status, this.message, this.data});

  AllTaskDetails.fromJson(Map<String, dynamic> json) {
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
  String? ticket;
  int? ticketType;
  int? ticketStatus;
  int? productId;
  int? ticketId;
  String? image;
  String? description;
  String? address;
  String? city;
  String? state;
  int? id;
  String? productName;
  String? productInvoice;
  String? productImage;
  String? warrantyCard;
  String? purchasedDate;
  String? warrantyDate;
  String? invoiceDate;
  String? name;
  String? mobile;
  String? reasonImage;
  String? reasonDes;
  String? proStatus;

  Data(
      {this.createdAt,
        this.ticket,
        this.ticketType,
        this.ticketStatus,
        this.productId,
        this.ticketId,
        this.image,
        this.description,
        this.address,
        this.city,
        this.state,
        this.id,
        this.productName,
        this.productInvoice,
        this.productImage,
        this.warrantyCard,
        this.purchasedDate,
        this.warrantyDate,
        this.invoiceDate,
        this.name,
        this.mobile,
        this.reasonImage,
        this.reasonDes,
        this.proStatus});

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    ticket = json['ticket'];
    ticketType = json['ticket_type'];
    ticketStatus = json['ticketStatus'];
    productId = json['product_id'];
    ticketId = json['ticketId'];
    image = json['image'];
    description = json['description'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    id = json['id'];
    productName = json['product_name'];
    productInvoice = json['product_invoice'];
    productImage = json['product_image'];
    warrantyCard = json['warranty_card'];
    purchasedDate = json['purchased_date'];
    warrantyDate = json['warranty_date'];
    invoiceDate = json['invoice_date'];
    name = json['name'];
    mobile = json['mobile'];
    reasonImage = json['reason_image'];
    reasonDes = json['reason_des'];
    proStatus = json['pro_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['ticket'] = this.ticket;
    data['ticket_type'] = this.ticketType;
    data['ticketStatus'] = this.ticketStatus;
    data['product_id'] = this.productId;
    data['ticketId'] = this.ticketId;
    data['image'] = this.image;
    data['description'] = this.description;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_invoice'] = this.productInvoice;
    data['product_image'] = this.productImage;
    data['warranty_card'] = this.warrantyCard;
    data['purchased_date'] = this.purchasedDate;
    data['warranty_date'] = this.warrantyDate;
    data['invoice_date'] = this.invoiceDate;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['reason_image'] = this.reasonImage;
    data['reason_des'] = this.reasonDes;
    data['pro_status'] = this.proStatus;
    return data;
  }
}
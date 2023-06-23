class GetProductModel {
  int? status;
  String? message;
  List<Data>? data;

  GetProductModel({this.status, this.message, this.data});

  GetProductModel.fromJson(Map<String, dynamic> json) {
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
  String? productName;
  String? productImage;
  String? productInvoice;
  String? warrantyCard;
  String? purchasedDate;
  String? warrantyDate;
  String? invoiceDate;
  String? invoiceNo;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? serviceStatus;

  Data(
      {this.id,
        this.productName,
        this.productImage,
        this.productInvoice,
        this.warrantyCard,
        this.purchasedDate,
        this.warrantyDate,
        this.invoiceDate,
        this.invoiceNo,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.serviceStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    productInvoice = json['product_invoice'];
    warrantyCard = json['warranty_card'];
    purchasedDate = json['purchased_date'];
    warrantyDate = json['warranty_date'];
    invoiceDate = json['invoice_date'];
    invoiceNo = json['invoice_no'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    serviceStatus = json['service_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['product_invoice'] = this.productInvoice;
    data['warranty_card'] = this.warrantyCard;
    data['purchased_date'] = this.purchasedDate;
    data['warranty_date'] = this.warrantyDate;
    data['invoice_date'] = this.invoiceDate;
    data['invoice_no'] = this.invoiceNo;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['service_status'] = this.serviceStatus;
    return data;
  }
}
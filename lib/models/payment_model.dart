class AllPaymentModel {
  int? status;
  String? message;
  List<Data>? data;

  AllPaymentModel({this.status, this.message, this.data});

  AllPaymentModel.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  String? customerInvoice;
  String? customerInvoiceAmount;
  String? technicianInvoice;
  String? technicianInvoiceAmount;
  int? invoiceStatus;
  String? paymentReceipt;
  String? toBePaid;
  String? ticket;
  String? name;
  String? status;

  Data(
      {this.id,
        this.createdAt,
        this.customerInvoice,
        this.customerInvoiceAmount,
        this.technicianInvoice,
        this.technicianInvoiceAmount,
        this.invoiceStatus,
        this.paymentReceipt,
        this.toBePaid,
        this.ticket,
        this.name,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    customerInvoice = json['customer_invoice'];
    customerInvoiceAmount = json['customer_invoice_amount'];
    technicianInvoice = json['technician_invoice'];
    technicianInvoiceAmount = json['technician_invoice_amount'];
    invoiceStatus = json['invoice_status'];
    paymentReceipt = json['payment_receipt'];
    toBePaid = json['to_be_paid'];
    ticket = json['ticket'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['customer_invoice'] = this.customerInvoice;
    data['customer_invoice_amount'] = this.customerInvoiceAmount;
    data['technician_invoice'] = this.technicianInvoice;
    data['technician_invoice_amount'] = this.technicianInvoiceAmount;
    data['invoice_status'] = this.invoiceStatus;
    data['payment_receipt'] = this.paymentReceipt;
    data['to_be_paid'] = this.toBePaid;
    data['ticket'] = this.ticket;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
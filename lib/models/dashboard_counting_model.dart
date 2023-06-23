class DashboardCount {
  int? status;
  String? message;
  Data? data;

  DashboardCount({this.status, this.message, this.data});

  DashboardCount.fromJson(Map<String, dynamic> json) {
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
  int? totalTicket;
  int? resolvedTicket;
  int? rejectTicket;
  int? activeTicket;
  int? totalProduct;
  int? eCatalogue;
  int? totalStore;
  int? servicesHistory;

  Data(
      {this.totalTicket,
        this.resolvedTicket,
        this.rejectTicket,
        this.activeTicket,
        this.totalProduct,
        this.eCatalogue,
        this.totalStore,
        this.servicesHistory});

  Data.fromJson(Map<String, dynamic> json) {
    totalTicket = json['total_ticket'];
    resolvedTicket = json['resolved_ticket'];
    rejectTicket = json['reject_ticket'];
    activeTicket = json['active_ticket'];
    totalProduct = json['total_product'];
    eCatalogue = json['eCatalogue'];
    totalStore = json['total_store'];
    servicesHistory = json['services_history'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_ticket'] = this.totalTicket;
    data['resolved_ticket'] = this.resolvedTicket;
    data['reject_ticket'] = this.rejectTicket;
    data['active_ticket'] = this.activeTicket;
    data['total_product'] = this.totalProduct;
    data['eCatalogue'] = this.eCatalogue;
    data['total_store'] = this.totalStore;
    data['services_history'] = this.servicesHistory;
    return data;
  }
}
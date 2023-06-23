class eCatalogModel {
  int? status;
  String? message;
  List<Data>? data;

  eCatalogModel({this.status, this.message, this.data});

  eCatalogModel.fromJson(Map<String, dynamic> json) {
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
  String? catalogueName;
  String? productCatalogue;
  String? createdAt;
  String? updatedAt;
  String? date;

  Data(
      {this.id,
        this.catalogueName,
        this.productCatalogue,
        this.createdAt,
        this.updatedAt,
        this.date});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catalogueName = json['catalogue_name'];
    productCatalogue = json['product_catalogue'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catalogue_name'] = this.catalogueName;
    data['product_catalogue'] = this.productCatalogue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['date'] = this.date;
    return data;
  }
}
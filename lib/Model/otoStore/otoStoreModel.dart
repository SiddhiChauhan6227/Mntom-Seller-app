class OtoStore {
  bool? error;
  String? message;
  String? total;
  List<OtoStoreModel>? data;

  OtoStore({this.error, this.message, this.total, this.data});

  OtoStore.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    total = json['total'];
    if (json['data'] != null) {
      data = <OtoStoreModel>[];
      json['data'].forEach((v) {
        data!.add(new OtoStoreModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OtoStoreModel {
  String? id;
  int? warehouseCode;
  String? sellerId;
  String? companyId;
  String? storeName;
  String? storeId;
  String? warehouseName;
  String? warehouseCity;
  String? warehouseId;
  String? storeLogo;
  String? createdAt;

  OtoStoreModel({
    this.id,
    this.sellerId,
    this.warehouseCode,
    this.companyId,
    this.storeName,
    this.storeId,
    this.warehouseName,
    this.warehouseCity,
    this.warehouseId,
    this.storeLogo,
    this.createdAt,
  });

  OtoStoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    sellerId = json['seller_id']?.toString();
    companyId = json['company_id']?.toString();
    warehouseCode = json['warehouse_code'];
    storeName = json['store_name'];
    storeId = json['store_id']?.toString();
    warehouseName = json['warehouse_name'];
    warehouseCity = json['warehouse_city'];
    warehouseId = json['warehouse_id']?.toString();
    storeLogo = json['store_logo'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['seller_id'] = sellerId;
    data['company_id'] = companyId;
    data['store_name'] = storeName;
    data['store_id'] = storeId;
    data['warehouse_code'] = warehouseCode;
    data['warehouse_name'] = warehouseName;
    data['warehouse_city'] = warehouseCity;
    data['warehouse_id'] = warehouseId;
    data['store_logo'] = storeLogo;
    data['created_at'] = createdAt;
    return data;
  }
}


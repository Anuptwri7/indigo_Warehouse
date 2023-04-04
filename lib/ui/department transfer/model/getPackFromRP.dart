class GetPacksFromRP {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  GetPacksFromRP({this.count, this.next, this.previous, this.results});

  GetPacksFromRP.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  String? code;
  int? departmentTransferMaster;
  List<SalePackingTypeCode>? salePackingTypeCode;

  Results(
      {this.id,
        this.code,
        this.departmentTransferMaster,
        this.salePackingTypeCode});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    departmentTransferMaster = json['department_transfer_master'];
    if (json['sale_packing_type_code'] != null) {
      salePackingTypeCode = <SalePackingTypeCode>[];
      json['sale_packing_type_code'].forEach((v) {
        salePackingTypeCode!.add(new SalePackingTypeCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['department_transfer_master'] = this.departmentTransferMaster;
    if (this.salePackingTypeCode != null) {
      data['sale_packing_type_code'] =
          this.salePackingTypeCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalePackingTypeCode {
  int? id;
  String? code;
  int? packingTypeCode;
  Null? customerOrderDetail;
  Null? refSalePackingTypeCode;
  String? locationCode;

  SalePackingTypeCode(
      {this.id,
        this.code,
        this.packingTypeCode,
        this.customerOrderDetail,
        this.refSalePackingTypeCode,
        this.locationCode});

  SalePackingTypeCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    packingTypeCode = json['packing_type_code'];
    customerOrderDetail = json['customer_order_detail'];
    refSalePackingTypeCode = json['ref_sale_packing_type_code'];
    locationCode = json['location_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['packing_type_code'] = this.packingTypeCode;
    data['customer_order_detail'] = this.customerOrderDetail;
    data['ref_sale_packing_type_code'] = this.refSalePackingTypeCode;
    data['location_code'] = this.locationCode;
    return data;
  }
}
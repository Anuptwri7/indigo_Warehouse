class NewRepackageListings {
  int? count;
  String? next;
  String? previous;
  List<Result>? results;

  NewRepackageListings({this.count, this.next, this.previous, this.results});

  NewRepackageListings.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Result>[];
      json['results'].forEach((v) {
        results!.add(new Result.fromJson(v));
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

class Result {
  int? id;
  String? code;
  int? saleMaster;
  List<newSalePackingTypeCode>? salePackingTypeCode;

  Result({this.id, this.code, this.saleMaster, this.salePackingTypeCode});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    saleMaster = json['sale_master'];
    if (json['sale_packing_type_code'] != null) {
      salePackingTypeCode = <newSalePackingTypeCode>[];
      json['sale_packing_type_code'].forEach((v) {
        salePackingTypeCode!.add(new newSalePackingTypeCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['sale_master'] = this.saleMaster;
    if (this.salePackingTypeCode != null) {
      data['sale_packing_type_code'] =
          this.salePackingTypeCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class newSalePackingTypeCode {
  int? id;
  String? code;
  int? packingTypeCode;
  int? customerOrderDetail;
  Null? refnewSalePackingTypeCode;
  String? locationCode;

  newSalePackingTypeCode(
      {this.id,
        this.code,
        this.packingTypeCode,
        this.customerOrderDetail,
        this.refnewSalePackingTypeCode,
        this.locationCode});

  newSalePackingTypeCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    packingTypeCode = json['packing_type_code'];
    customerOrderDetail = json['customer_order_detail'];
    refnewSalePackingTypeCode = json['ref_sale_packing_type_code'];
    locationCode = json['location_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['packing_type_code'] = this.packingTypeCode;
    data['customer_order_detail'] = this.customerOrderDetail;
    data['ref_sale_packing_type_code'] = this.refnewSalePackingTypeCode;
    data['location_code'] = this.locationCode;
    return data;
  }
}
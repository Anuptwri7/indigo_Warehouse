class RepackagingListModel {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  RepackagingListModel({this.count, this.next, this.previous, this.results});

  RepackagingListModel.fromJson(Map<String, dynamic> json) {
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
  int? item;
  String? itemName;
  String? itemCategoryName;
  String? batchNo;
  List<SalePackingTypeCode>? salePackingTypeCode;

  Results(
      {this.id,
        this.item,
        this.itemName,
        this.itemCategoryName,
        this.batchNo,
        this.salePackingTypeCode});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    item = json['item'];
    itemName = json['item_name'];
    itemCategoryName = json['item_category_name'];
    batchNo = json['batch_no'];
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
    data['item'] = this.item;
    data['item_name'] = this.itemName;
    data['item_category_name'] = this.itemCategoryName;
    data['batch_no'] = this.batchNo;
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
  int? customerOrderDetail;
  Null? refSalePackingTypeCode;
  List<SalePackingTypeDetailCode>? salePackingTypeDetailCode;
  String? locationCode;

  SalePackingTypeCode(
      {this.id,
        this.code,
        this.packingTypeCode,
        this.customerOrderDetail,
        this.refSalePackingTypeCode,
        this.salePackingTypeDetailCode,
        this.locationCode});

  SalePackingTypeCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    packingTypeCode = json['packing_type_code'];
    customerOrderDetail = json['customer_order_detail'];
    refSalePackingTypeCode = json['ref_sale_packing_type_code'];
    if (json['sale_packing_type_detail_code'] != null) {
      salePackingTypeDetailCode = <SalePackingTypeDetailCode>[];
      json['sale_packing_type_detail_code'].forEach((v) {
        salePackingTypeDetailCode!
            .add(new SalePackingTypeDetailCode.fromJson(v));
      });
    }
    locationCode = json['location_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['packing_type_code'] = this.packingTypeCode;
    data['customer_order_detail'] = this.customerOrderDetail;
    data['ref_sale_packing_type_code'] = this.refSalePackingTypeCode;
    if (this.salePackingTypeDetailCode != null) {
      data['sale_packing_type_detail_code'] =
          this.salePackingTypeDetailCode!.map((v) => v.toJson()).toList();
    }
    data['location_code'] = this.locationCode;
    return data;
  }
}

class SalePackingTypeDetailCode {
  int? id;
  int? packingTypeDetailCode;
  Null? refSalePackingTypeDetailCode;
  String? code;

  SalePackingTypeDetailCode(
      {this.id,
        this.packingTypeDetailCode,
        this.refSalePackingTypeDetailCode,
        this.code});

  SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packingTypeDetailCode = json['packing_type_detail_code'];
    refSalePackingTypeDetailCode = json['ref_sale_packing_type_detail_code'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['packing_type_detail_code'] = this.packingTypeDetailCode;
    data['ref_sale_packing_type_detail_code'] =
        this.refSalePackingTypeDetailCode;
    data['code'] = this.code;
    return data;
  }
}
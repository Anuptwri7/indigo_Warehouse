import 'dart:convert';

RepackagingListModel repackagingListModelFromJson(String str) => RepackagingListModel.fromJson(json.decode(str));

String repackagingListModelToJson(RepackagingListModel data) => json.encode(data.toJson());

class RepackagingListModel {
  RepackagingListModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Results> results;

  factory RepackagingListModel.fromJson(Map<String, dynamic> json) => RepackagingListModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<Results>.from(json["results"].map((x) => Results.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Results {
  Results({
    required this.id,
    required this.item,
    required this.itemName,
    required this.itemCategoryName,
    required this.batchNo,
    required this.departmentTransferPackingTypes,
  });

  int id;
  int item;
  String itemName;
  String itemCategoryName;
  String batchNo;
  List<DepartmentTransferPackingType> departmentTransferPackingTypes;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    id: json["id"],
    item: json["item"],
    itemName: json["item_name"],
    itemCategoryName: json["item_category_name"],
    batchNo: json["batch_no"],
    departmentTransferPackingTypes: List<DepartmentTransferPackingType>.from(json["department_transfer_packing_types"].map((x) => DepartmentTransferPackingType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item": item,
    "item_name": itemName,
    "item_category_name": itemCategoryName,
    "batch_no": batchNo,
    "department_transfer_packing_types": List<dynamic>.from(departmentTransferPackingTypes.map((x) => x.toJson())),
  };
}

class DepartmentTransferPackingType {
  DepartmentTransferPackingType({
    required this.id,
    required this.code,
    required this.packingTypeCode,
    this.customerOrderDetail,
    this.refSalePackingTypeCode,
    required this.salePackingTypeDetailCode,
    required this.locationCode,
    required this.departmentTransferDetail,
  });

  int id;
  String code;
  int packingTypeCode;
  dynamic customerOrderDetail;
  dynamic refSalePackingTypeCode;
  List<SalePackingTypeDetailCode> salePackingTypeDetailCode;
  String locationCode;
  int departmentTransferDetail;

  factory DepartmentTransferPackingType.fromJson(Map<String, dynamic> json) => DepartmentTransferPackingType(
    id: json["id"],
    code: json["code"],
    packingTypeCode: json["packing_type_code"],
    customerOrderDetail: json["customer_order_detail"],
    refSalePackingTypeCode: json["ref_sale_packing_type_code"],
    salePackingTypeDetailCode: List<SalePackingTypeDetailCode>.from(json["sale_packing_type_detail_code"].map((x) => SalePackingTypeDetailCode.fromJson(x))),
    locationCode: json["location_code"],
    departmentTransferDetail: json["department_transfer_detail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "packing_type_code": packingTypeCode,
    "customer_order_detail": customerOrderDetail,
    "ref_sale_packing_type_code": refSalePackingTypeCode,
    "sale_packing_type_detail_code": List<dynamic>.from(salePackingTypeDetailCode.map((x) => x.toJson())),
    "location_code": locationCode,
    "department_transfer_detail": departmentTransferDetail,
  };
}

class SalePackingTypeDetailCode {
  SalePackingTypeDetailCode({
    required this.id,
    required this.packingTypeDetailCode,
    this.refSalePackingTypeDetailCode,
    required this.code,
  });

  int id;
  int packingTypeDetailCode;
  dynamic refSalePackingTypeDetailCode;
  String code;

  factory SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) => SalePackingTypeDetailCode(
    id: json["id"],
    packingTypeDetailCode: json["packing_type_detail_code"],
    refSalePackingTypeDetailCode: json["ref_sale_packing_type_detail_code"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "packing_type_detail_code": packingTypeDetailCode,
    "ref_sale_packing_type_detail_code": refSalePackingTypeDetailCode,
    "code": code,
  };
}
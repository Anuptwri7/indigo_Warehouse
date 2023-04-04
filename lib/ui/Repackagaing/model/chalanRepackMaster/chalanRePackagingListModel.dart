import 'dart:convert';

ChalanRepackageList chalanRepackageListFromJson(String str) => ChalanRepackageList.fromJson(json.decode(str));

String chalanRepackageListToJson(ChalanRepackageList data) => json.encode(data.toJson());

class ChalanRepackageList {
  ChalanRepackageList({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Results> results;

  factory ChalanRepackageList.fromJson(Map<String, dynamic> json) => ChalanRepackageList(
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
    required this.code,
    required this.chalanMaster,
    required this.salePackingTypeCode,
  });

  int id;
  String code;
  int chalanMaster;
  List<SalePackingTypeCode> salePackingTypeCode;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    id: json["id"],
    code: json["code"],
    chalanMaster: json["chalan_master"],
    salePackingTypeCode: List<SalePackingTypeCode>.from(json["sale_packing_type_code"].map((x) => SalePackingTypeCode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "chalan_master": chalanMaster,
    "sale_packing_type_code": List<dynamic>.from(salePackingTypeCode.map((x) => x.toJson())),
  };
}

class SalePackingTypeCode {
  SalePackingTypeCode({
    required this.id,
    required this.code,
    required this.packingTypeCode,
    required this.customerOrderDetail,
    this.refSalePackingTypeCode,
    required this.locationCode,
  });

  int id;
  String code;
  int packingTypeCode;
  int customerOrderDetail;
  dynamic refSalePackingTypeCode;
  String locationCode;

  factory SalePackingTypeCode.fromJson(Map<String, dynamic> json) => SalePackingTypeCode(
    id: json["id"],
    code: json["code"],
    packingTypeCode: json["packing_type_code"],
    customerOrderDetail: json["customer_order_detail"],
    refSalePackingTypeCode: json["ref_sale_packing_type_code"],
    locationCode: json["location_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "packing_type_code": packingTypeCode,
    "customer_order_detail": customerOrderDetail,
    "ref_sale_packing_type_code": refSalePackingTypeCode,
    "location_code": locationCode,
  };
}

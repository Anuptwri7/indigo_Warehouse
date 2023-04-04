// To parse this JSON data, do
//
//     final newRepackageListings = newRepackageListingsFromJson(jsonString);

import 'dart:convert';

NewRepackageListings newRepackageListingsFromJson(String str) => NewRepackageListings.fromJson(json.decode(str));

String newRepackageListingsToJson(NewRepackageListings data) => json.encode(data.toJson());

class NewRepackageListings {
  NewRepackageListings({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory NewRepackageListings.fromJson(Map<String, dynamic> json) => NewRepackageListings(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    required this.id,
    required this.code,
    required this.chalanMaster,
    required this.salePackingTypeCode,
  });

  int id;
  String code;
  int chalanMaster;
  List<newSalePackingTypeCode> salePackingTypeCode;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    code: json["code"],
    chalanMaster: json["chalan_master"],
    salePackingTypeCode: List<newSalePackingTypeCode>.from(json["sale_packing_type_code"].map((x) => newSalePackingTypeCode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "chalan_master": chalanMaster,
    "sale_packing_type_code": List<dynamic>.from(salePackingTypeCode.map((x) => x.toJson())),
  };
}

class newSalePackingTypeCode {
  newSalePackingTypeCode({
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
  LocationCode? locationCode;

  factory newSalePackingTypeCode.fromJson(Map<String, dynamic> json) => newSalePackingTypeCode(
    id: json["id"],
    code: json["code"],
    packingTypeCode: json["packing_type_code"],
    customerOrderDetail: json["customer_order_detail"],
    refSalePackingTypeCode: json["ref_sale_packing_type_code"],
    locationCode: locationCodeValues.map[json["location_code"]],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "packing_type_code": packingTypeCode,
    "customer_order_detail": customerOrderDetail,
    "ref_sale_packing_type_code": refSalePackingTypeCode,
    "location_code": locationCodeValues.reverse[locationCode],
  };
}

enum LocationCode { RM1_RK01 }

final locationCodeValues = EnumValues({
  "RM1-Rk01": LocationCode.RM1_RK01
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

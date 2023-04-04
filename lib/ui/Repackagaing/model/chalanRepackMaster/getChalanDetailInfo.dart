
import 'dart:convert';

GetChalanDetailInfo getChalanDetailInfoFromJson(String str) => GetChalanDetailInfo.fromJson(json.decode(str));

String getChalanDetailInfoToJson(GetChalanDetailInfo data) => json.encode(data.toJson());

class GetChalanDetailInfo {
  GetChalanDetailInfo({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory GetChalanDetailInfo.fromJson(Map<String, dynamic> json) => GetChalanDetailInfo(
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
    required this.item,
    required this.itemName,
    required this.itemCategoryName,
    required this.batchNo,
    required this.chalanPackingTypes,
  });

  int id;
  int item;
  String itemName;
  String itemCategoryName;
  String batchNo;
  List<ChalanPackingType> chalanPackingTypes;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    item: json["item"],
    itemName: json["item_name"],
    itemCategoryName: json["item_category_name"],
    batchNo: json["batch_no"],
    chalanPackingTypes: List<ChalanPackingType>.from(json["chalan_packing_types"].map((x) => ChalanPackingType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item": item,
    "item_name": itemName,
    "item_category_name": itemCategoryName,
    "batch_no": batchNo,
    "chalan_packing_types": List<dynamic>.from(chalanPackingTypes.map((x) => x.toJson())),
  };
}

class ChalanPackingType {
  ChalanPackingType({
    required this.id,
    required this.code,
    required this.packingTypeCode,
    required this.customerOrderDetail,
    this.refSalePackingTypeCode,
    required this.salePackingTypeDetailCode,
    required this.locationCode,
  });

  int id;
  String code;
  int packingTypeCode;
  int customerOrderDetail;
  dynamic refSalePackingTypeCode;
  List<dynamic> salePackingTypeDetailCode;
  String locationCode;

  factory ChalanPackingType.fromJson(Map<String, dynamic> json) => ChalanPackingType(
    id: json["id"],
    code: json["code"],
    packingTypeCode: json["packing_type_code"],
    customerOrderDetail: json["customer_order_detail"],
    refSalePackingTypeCode: json["ref_sale_packing_type_code"],
    salePackingTypeDetailCode: List<dynamic>.from(json["sale_packing_type_detail_code"].map((x) => x)),
    locationCode: json["location_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "packing_type_code": packingTypeCode,
    "customer_order_detail": customerOrderDetail,
    "ref_sale_packing_type_code": refSalePackingTypeCode,
    "sale_packing_type_detail_code": List<dynamic>.from(salePackingTypeDetailCode.map((x) => x)),
    "location_code": locationCode,
  };
}

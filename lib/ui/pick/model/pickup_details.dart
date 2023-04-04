

import 'dart:convert';

PickUpDetails pickUpDetailsFromJson(String str) => PickUpDetails.fromJson(json.decode(str));

String pickUpDetailsToJson(PickUpDetails data) => json.encode(data.toJson());

class PickUpDetails {
  PickUpDetails({
    required this.count,
    required this.next,
    this.previous,
    required this.results,
  });

  int count;
  String next;
  dynamic previous;
  List<Result> results;

  factory PickUpDetails.fromJson(Map<String, dynamic> json) => PickUpDetails(
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
    required this.customerPackingTypes,
    required this.itemName,
    required this.itemCategoryName,
    required this.createdByUserName,
    required this.orderByBatch,
    this.pickedByName,
    required this.itemIsSerializable,
    required this.createdDateAd,
    required this.createdDateBs,
    required this.deviceType,
    required this.appType,
    required this.qty,
    required this.purchaseCost,
    required this.saleCost,
    required this.discountable,
    required this.taxable,
    required this.taxRate,
    required this.taxAmount,
    required this.discountRate,
    required this.discountAmount,
    required this.grossAmount,
    required this.netAmount,
    required this.cancelled,
    required this.picked,
    required this.remarks,
    required this.createdBy,
    required this.order,
    required this.item,
    required this.itemCategory,
    required this.purchaseDetail,
    this.pickedBy,
  });

  int id;
  List<CustomerPackingType> customerPackingTypes;
  String itemName;
  String itemCategoryName;
  String createdByUserName;
  bool orderByBatch;
  dynamic pickedByName;
  bool itemIsSerializable;
  DateTime createdDateAd;
  DateTime createdDateBs;
  int deviceType;
  int appType;
  double qty;
  String purchaseCost;
  String saleCost;
  bool discountable;
  bool taxable;
  String taxRate;
  String taxAmount;
  String discountRate;
  String discountAmount;
  String grossAmount;
  String netAmount;
  bool cancelled;
  bool picked;
  String remarks;
  int createdBy;
  int order;
  int item;
  int itemCategory;
  int purchaseDetail;
  dynamic pickedBy;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    customerPackingTypes: List<CustomerPackingType>.from(json["customer_packing_types"].map((x) => CustomerPackingType.fromJson(x))),
    itemName: json["item_name"],
    itemCategoryName: json["item_category_name"],
    createdByUserName: json["created_by_user_name"],
    orderByBatch: json["order_by_batch"],
    pickedByName: json["picked_by_name"],
    itemIsSerializable: json["item_is_serializable"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    deviceType: json["device_type"],
    appType: json["app_type"],
    qty: double.parse(json["qty"]),
    purchaseCost: json["purchase_cost"],
    saleCost: json["sale_cost"],
    discountable: json["discountable"],
    taxable: json["taxable"],
    taxRate: json["tax_rate"],
    taxAmount: json["tax_amount"],
    discountRate: json["discount_rate"],
    discountAmount: json["discount_amount"],
    grossAmount: json["gross_amount"],
    netAmount: json["net_amount"],
    cancelled: json["cancelled"],
    picked: json["picked"],
    remarks: json["remarks"],
    createdBy: json["created_by"],
    order: json["order"],
    item: json["item"],
    itemCategory: json["item_category"],
    purchaseDetail: json["purchase_detail"],
    pickedBy: json["picked_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_packing_types": List<dynamic>.from(customerPackingTypes.map((x) => x.toJson())),
    "item_name": itemNameValues.reverse[itemName],
    "item_category_name": itemCategoryNameValues.reverse[itemCategoryName],
    "created_by_user_name": createdByUserNameValues.reverse[createdByUserName],
    "order_by_batch": orderByBatch,
    "picked_by_name": pickedByName,
    "item_is_serializable": itemIsSerializable,
    "created_date_ad": createdDateAd.toIso8601String(),
    "created_date_bs": "${createdDateBs.year.toString().padLeft(4, '0')}-${createdDateBs.month.toString().padLeft(2, '0')}-${createdDateBs.day.toString().padLeft(2, '0')}",
    "device_type": deviceType,
    "app_type": appType,
    "qty": qty,
    "purchase_cost": purchaseCost,
    "sale_cost": saleCost,
    "discountable": discountable,
    "taxable": taxable,
    "tax_rate": taxRate,
    "tax_amount": taxAmount,
    "discount_rate": discountRate,
    "discount_amount": discountAmount,
    "gross_amount": grossAmount,
    "net_amount": netAmount,
    "cancelled": cancelled,
    "picked": picked,
    "remarks": remarks,
    "created_by": createdBy,
    "order": order,
    "item": item,
    "item_category": itemCategory,
    "purchase_detail": purchaseDetail,
    "picked_by": pickedBy,
  };
}

enum CreatedByUserName { ANKEET, SABINA }

final createdByUserNameValues = EnumValues({
  "ankeet": CreatedByUserName.ANKEET,
  "sabina": CreatedByUserName.SABINA
});

class CustomerPackingType {
  CustomerPackingType({
    required this.id,
    required this.locationCode,
    required this.location,
    required this.code,
    required this.qty,
    this.saleDetail,
    required this.packingTypeCode,
    required this.salePackingTypeDetailCode,
  });

  int id;
  LocationCode locationCode;
  int location;
  String code;
  double qty;
  int? saleDetail;
  int packingTypeCode;
  List<SalePackingTypeDetailCode> salePackingTypeDetailCode;

  factory CustomerPackingType.fromJson(Map<String, dynamic> json) => CustomerPackingType(
    id: json["id"],
    locationCode: locationCodeValues.map[json["location_code"]]!,
    location: json["location"],
    code: json["code"],
    qty: double.parse(json["qty"]),
    saleDetail: json["sale_detail"],
    packingTypeCode: json["packing_type_code"],
    salePackingTypeDetailCode: List<SalePackingTypeDetailCode>.from(json["sale_packing_type_detail_code"].map((x) => SalePackingTypeDetailCode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location_code": locationCodeValues.reverse[locationCode],
    "location": location,
    "code": code,
    "qty": qty,
    "sale_detail": saleDetail,
    "packing_type_code": packingTypeCode,
    "sale_packing_type_detail_code": List<dynamic>.from(salePackingTypeDetailCode.map((x) => x.toJson())),
  };
}

enum LocationCode { RK1_RK01 }

final locationCodeValues = EnumValues({
  "RK1-RK01": LocationCode.RK1_RK01
});

class SalePackingTypeDetailCode {
  SalePackingTypeDetailCode({
    required this.id,
    required this.packingTypeDetailCode,
    required this.code,
  });

  int id;
  int packingTypeDetailCode;
  String code;

  factory SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) => SalePackingTypeDetailCode(
    id: json["id"],
    packingTypeDetailCode: json["packing_type_detail_code"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "packing_type_detail_code": packingTypeDetailCode,
    "code": code,
  };
}

enum ItemCategoryName { PRODUCT }

final itemCategoryNameValues = EnumValues({
  "Product": ItemCategoryName.PRODUCT
});

enum ItemName { DEMO, ZC_300, DS_2208 }

final itemNameValues = EnumValues({
  "Demo": ItemName.DEMO,
  "DS 2208": ItemName.DS_2208,
  "ZC 300": ItemName.ZC_300
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

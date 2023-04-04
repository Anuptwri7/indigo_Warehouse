import 'dart:convert';

ChalanMasterListings chalanMasterListingsFromJson(String str) => ChalanMasterListings.fromJson(json.decode(str));

String chalanMasterListingsToJson(ChalanMasterListings data) => json.encode(data.toJson());

class ChalanMasterListings {
  ChalanMasterListings({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Results> results;

  factory ChalanMasterListings.fromJson(Map<String, dynamic> json) => ChalanMasterListings(
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
    required this.chalanNo,
    required this.status,
    required this.customer,
    this.discountScheme,
    required this.discountRate,
    required this.totalDiscount,
    required this.totalTax,
    required this.subTotal,
    required this.totalDiscountableAmount,
    required this.totalTaxableAmount,
    required this.totalNonTaxableAmount,
    required this.refOrderMaster,
    required this.grandTotal,
    required this.remarks,
    required this.createdDateAd,
    required this.createdDateBs,
    required this.createdByUserName,
    required this.statusDisplay,
    required this.orderNo,
    this.refChalanMaster,
    required this.returnDropped,
  });

  int id;
  String chalanNo;
  int status;
  Customer customer;
  dynamic discountScheme;
  String discountRate;
  String totalDiscount;
  String totalTax;
  String subTotal;
  String totalDiscountableAmount;
  String totalTaxableAmount;
  String totalNonTaxableAmount;
  int refOrderMaster;
  String grandTotal;
  String remarks;
  DateTime createdDateAd;
  DateTime createdDateBs;
  String createdByUserName;
  String statusDisplay;
  String orderNo;
  dynamic refChalanMaster;
  bool returnDropped;

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    id: json["id"],
    chalanNo: json["chalan_no"],
    status: json["status"],
    customer: Customer.fromJson(json["customer"]),
    discountScheme: json["discount_scheme"],
    discountRate: json["discount_rate"],
    totalDiscount: json["total_discount"],
    totalTax: json["total_tax"],
    subTotal: json["sub_total"],
    totalDiscountableAmount: json["total_discountable_amount"],
    totalTaxableAmount: json["total_taxable_amount"],
    totalNonTaxableAmount: json["total_non_taxable_amount"],
    refOrderMaster: json["ref_order_master"],
    grandTotal: json["grand_total"],
    remarks: json["remarks"],
    createdDateAd: DateTime.parse(json["created_date_ad"]),
    createdDateBs: DateTime.parse(json["created_date_bs"]),
    createdByUserName: json["created_by_user_name"],
    statusDisplay: json["status_display"],
    orderNo: json["order_no"],
    refChalanMaster: json["ref_chalan_master"],
    returnDropped: json["return_dropped"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chalan_no": chalanNo,
    "status": status,
    "customer": customer.toJson(),
    "discount_scheme": discountScheme,
    "discount_rate": discountRate,
    "total_discount": totalDiscount,
    "total_tax": totalTax,
    "sub_total": subTotal,
    "total_discountable_amount": totalDiscountableAmount,
    "total_taxable_amount": totalTaxableAmount,
    "total_non_taxable_amount": totalNonTaxableAmount,
    "ref_order_master": refOrderMaster,
    "grand_total": grandTotal,
    "remarks": remarks,
    "created_date_ad": createdDateAd.toIso8601String(),
    "created_date_bs": "${createdDateBs.year.toString().padLeft(4, '0')}-${createdDateBs.month.toString().padLeft(2, '0')}-${createdDateBs.day.toString().padLeft(2, '0')}",
    "created_by_user_name": createdByUserName,
    "status_display": statusDisplay,
    "order_no": orderNo,
    "ref_chalan_master": refChalanMaster,
    "return_dropped": returnDropped,
  };
}

class Customer {
  Customer({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.panVatNo,
    required this.phoneNo,
    required this.address,
  });

  int id;
  String firstName;
  String middleName;
  String lastName;
  String panVatNo;
  String phoneNo;
  String address;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    lastName: json["last_name"],
    panVatNo: json["pan_vat_no"],
    phoneNo: json["phone_no"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "pan_vat_no": panVatNo,
    "phone_no": phoneNo,
    "address": address,
  };
}

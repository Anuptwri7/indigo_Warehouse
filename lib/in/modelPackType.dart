class PackType {
  int? id;
  String? orderNo;
  String? createdDateBs;
  String? createdDateAd;
  String? grandTotal;
  String? createdByUserName;
  String? remarks;
  String? endUserName;
  String? termsOfPayment;
  String? shipmentTerms;
  String? attendee;
  Supplier? supplier;
  List<PurchaseOrderDetails>? purchaseOrderDetails;
  Null? currency;
  String? currencyExchangeRate;
  List<Null>? purchaseOrderDocuments;
  Department? department;

  PackType(
      {this.id,
        this.orderNo,
        this.createdDateBs,
        this.createdDateAd,
        this.grandTotal,
        this.createdByUserName,
        this.remarks,
        this.endUserName,
        this.termsOfPayment,
        this.shipmentTerms,
        this.attendee,
        this.supplier,
        this.purchaseOrderDetails,
        this.currency,
        this.currencyExchangeRate,
        this.purchaseOrderDocuments,
        this.department});

  PackType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    createdDateBs = json['created_date_bs'];
    createdDateAd = json['created_date_ad'];
    grandTotal = json['grand_total'];
    createdByUserName = json['created_by_user_name'];
    remarks = json['remarks'];
    endUserName = json['end_user_name'];
    termsOfPayment = json['terms_of_payment'];
    shipmentTerms = json['shipment_terms'];
    attendee = json['attendee'];
    supplier = json['supplier'] != null
        ? new Supplier.fromJson(json['supplier'])
        : null;
    if (json['purchase_order_details'] != null) {
      purchaseOrderDetails = <PurchaseOrderDetails>[];
      json['purchase_order_details'].forEach((v) {
        purchaseOrderDetails!.add(new PurchaseOrderDetails.fromJson(v));
      });
    }
    currency = json['currency'];
    currencyExchangeRate = json['currency_exchange_rate'];

    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_no'] = this.orderNo;
    data['created_date_bs'] = this.createdDateBs;
    data['created_date_ad'] = this.createdDateAd;
    data['grand_total'] = this.grandTotal;
    data['created_by_user_name'] = this.createdByUserName;
    data['remarks'] = this.remarks;
    data['end_user_name'] = this.endUserName;
    data['terms_of_payment'] = this.termsOfPayment;
    data['shipment_terms'] = this.shipmentTerms;
    data['attendee'] = this.attendee;
    if (this.supplier != null) {
      data['supplier'] = this.supplier!.toJson();
    }
    if (this.purchaseOrderDetails != null) {
      data['purchase_order_details'] =
          this.purchaseOrderDetails!.map((v) => v.toJson()).toList();
    }
    data['currency'] = this.currency;
    data['currency_exchange_rate'] = this.currencyExchangeRate;
    if (this.purchaseOrderDocuments != null) {

    }
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    return data;
  }
}

class Supplier {
  int? id;
  String? name;
  String? address;
  String? country;

  Supplier({this.id, this.name, this.address, this.country});

  Supplier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['country'] = this.country;
    return data;
  }
}

class PurchaseOrderDetails {
  int? id;
  String? itemName;
  String? itemCategoryName;
  String? itemHarmonicCode;
  String? itemBasicInfo;
  int? packingType;
  int? item;
  String? receivedQty;
  int? itemCategory;
  String? qty;
  bool? itemTaxable;
  int? itemTaxRate;
  bool? itemDiscountable;
  String? netAmount;
  int? grossAmount;
  String? itemCode;
  String? purchaseCost;
  List<PackingTypeDetailsItemwise>? packingTypeDetailsItemwise;
  PackingTypeDetail? packingTypeDetail;
  bool? cancelled;
  bool? itemExpirable;

  PurchaseOrderDetails(
      {this.id,
        this.itemName,
        this.itemCategoryName,
        this.itemHarmonicCode,
        this.itemBasicInfo,
        this.packingType,
        this.item,
        this.receivedQty,
        this.itemCategory,
        this.qty,
        this.itemTaxable,
        this.itemTaxRate,
        this.itemDiscountable,
        this.netAmount,
        this.grossAmount,
        this.itemCode,
        this.purchaseCost,
        this.packingTypeDetailsItemwise,
        this.packingTypeDetail,
        this.cancelled,
        this.itemExpirable});

  PurchaseOrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemCategoryName = json['item_category_name'];
    itemHarmonicCode = json['item_harmonic_code'];
    itemBasicInfo = json['item_basic_info'];
    packingType = json['packing_type'];
    item = json['item'];
    receivedQty = json['received_qty'];
    itemCategory = json['item_category'];
    qty = json['qty'];
    itemTaxable = json['item_taxable'];
    itemTaxRate = json['item_tax_rate'];
    itemDiscountable = json['item_discountable'];
    netAmount = json['net_amount'];
    grossAmount = json['gross_amount'];
    itemCode = json['item_code'];
    purchaseCost = json['purchase_cost'];
    if (json['packing_type_details_itemwise'] != null) {
      packingTypeDetailsItemwise = <PackingTypeDetailsItemwise>[];
      json['packing_type_details_itemwise'].forEach((v) {
        packingTypeDetailsItemwise!
            .add(new PackingTypeDetailsItemwise.fromJson(v));
      });
    }
    packingTypeDetail = json['packing_type_detail'] != null
        ? new PackingTypeDetail.fromJson(json['packing_type_detail'])
        : null;
    cancelled = json['cancelled'];
    itemExpirable = json['item_expirable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_name'] = this.itemName;
    data['item_category_name'] = this.itemCategoryName;
    data['item_harmonic_code'] = this.itemHarmonicCode;
    data['item_basic_info'] = this.itemBasicInfo;
    data['packing_type'] = this.packingType;
    data['item'] = this.item;
    data['received_qty'] = this.receivedQty;
    data['item_category'] = this.itemCategory;
    data['qty'] = this.qty;
    data['item_taxable'] = this.itemTaxable;
    data['item_tax_rate'] = this.itemTaxRate;
    data['item_discountable'] = this.itemDiscountable;
    data['net_amount'] = this.netAmount;
    data['gross_amount'] = this.grossAmount;
    data['item_code'] = this.itemCode;
    data['purchase_cost'] = this.purchaseCost;
    if (this.packingTypeDetailsItemwise != null) {
      data['packing_type_details_itemwise'] =
          this.packingTypeDetailsItemwise!.map((v) => v.toJson()).toList();
    }
    if (this.packingTypeDetail != null) {
      data['packing_type_detail'] = this.packingTypeDetail!.toJson();
    }
    data['cancelled'] = this.cancelled;
    data['item_expirable'] = this.itemExpirable;
    return data;
  }
}

class PackingTypeDetailsItemwise {
  int? id;
  String? packingTypeName;
  int? deviceType;
  int? appType;
  String? packQty;
  int? packingType;

  PackingTypeDetailsItemwise(
      {this.id,
        this.packingTypeName,
        this.deviceType,
        this.appType,
        this.packQty,
        this.packingType});

  PackingTypeDetailsItemwise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packingTypeName = json['packing_type_name'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    packQty = json['pack_qty'];
    packingType = json['packing_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['packing_type_name'] = this.packingTypeName;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['pack_qty'] = this.packQty;
    data['packing_type'] = this.packingType;
    return data;
  }
}

class PackingTypeDetail {
  int? id;
  int? packQty;
  String? packingTypeName;

  PackingTypeDetail({this.id, this.packQty, this.packingTypeName});

  PackingTypeDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packQty = json['pack_qty'];
    packingTypeName = json['packing_type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pack_qty'] = this.packQty;
    data['packing_type_name'] = this.packingTypeName;
    return data;
  }
}

class Department {
  int? id;
  String? name;
  String? code;
  String? allowSales;
  String? allowPurchase;

  Department(
      {this.id, this.name, this.code, this.allowSales, this.allowPurchase});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    allowSales = json['allow_sales'];
    allowPurchase = json['allow_purchase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['allow_sales'] = this.allowSales;
    data['allow_purchase'] = this.allowPurchase;
    return data;
  }
}
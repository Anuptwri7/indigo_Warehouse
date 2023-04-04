class OpenStockDetailsModel {
  int ? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  OpenStockDetailsModel({this.count, this.next, this.previous, this.results});

  OpenStockDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int ? id;
  List<PuPackTypeCodes> ?puPackTypeCodes;
  String ?purchaseNo;
  String? itemName;
  String ?itemCategoryName;
  String ?packingTypeName;
  String ?supplierName;
  int ? supplier;
  String ?createdDateAd;
  String ?createdDateBs;
  int ? deviceType;
  int ? appType;
  String ?purchaseCost;
  String ?saleCost;
  String ?qty;
  String? packQty;
  bool ?freePurchase;
  bool? taxable;
  String ?taxRate;
  String? taxAmount;
  bool ?discountable;
  bool? expirable;
  String ?discountRate;
  String ?discountAmount;
  String ?grossAmount;
  String ?netAmount;
  String ?expiryDateAd;
  String? expiryDateBs;
  String ?batchNo;
  int ? refTransferDetail;
  int ? createdBy;
  int ? purchase;
  int ? item;
  int ? itemCategory;
  int ? packingType;
  int ? packingTypeDetail;
  String ?refPurchaseOrderDetail;
  String? refPurchaseDetail;

  Results(
      {this.id,
        this.puPackTypeCodes,
        this.purchaseNo,
        this.itemName,
        this.itemCategoryName,
        this.packingTypeName,
        this.supplierName,
        this.supplier,
        this.createdDateAd,
        this.createdDateBs,
        this.deviceType,
        this.appType,
        this.purchaseCost,
        this.saleCost,
        this.qty,
        this.packQty,
        this.freePurchase,
        this.taxable,
        this.taxRate,
        this.taxAmount,
        this.discountable,
        this.expirable,
        this.discountRate,
        this.discountAmount,
        this.grossAmount,
        this.netAmount,
        this.expiryDateAd,
        this.expiryDateBs,
        this.batchNo,
        this.refTransferDetail,
        this.createdBy,
        this.purchase,
        this.item,
        this.itemCategory,
        this.packingType,
        this.packingTypeDetail,
        this.refPurchaseOrderDetail,
        this.refPurchaseDetail});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['pu_pack_type_codes'] != null) {
      puPackTypeCodes = <PuPackTypeCodes>[];
      json['pu_pack_type_codes'].forEach((v) {
        puPackTypeCodes!.add(new PuPackTypeCodes.fromJson(v));
      });
    }
    purchaseNo = json['purchase_no'];
    itemName = json['item_name'];
    itemCategoryName = json['item_category_name'];
    packingTypeName = json['packing_type_name'];
    supplierName = json['supplier_name'];
    supplier = json['supplier'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    purchaseCost = json['purchase_cost'];
    saleCost = json['sale_cost'];
    qty = json['qty'];
    packQty = json['pack_qty'];
    freePurchase = json['free_purchase'];
    taxable = json['taxable'];
    taxRate = json['tax_rate'];
    taxAmount = json['tax_amount'];
    discountable = json['discountable'];
    expirable = json['expirable'];
    discountRate = json['discount_rate'];
    discountAmount = json['discount_amount'];
    grossAmount = json['gross_amount'];
    netAmount = json['net_amount'];
    expiryDateAd = json['expiry_date_ad'];
    expiryDateBs = json['expiry_date_bs'];
    batchNo = json['batch_no'];
    refTransferDetail = json['ref_transfer_detail'];
    createdBy = json['created_by'];
    purchase = json['purchase'];
    item = json['item'];
    itemCategory = json['item_category'];
    packingType = json['packing_type'];
    packingTypeDetail = json['packing_type_detail'];
    refPurchaseOrderDetail = json['ref_purchase_order_detail'];
    refPurchaseDetail = json['ref_purchase_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.puPackTypeCodes != null) {
      data['pu_pack_type_codes'] =
          this.puPackTypeCodes!.map((v) => v.toJson()).toList();
    }
    data['purchase_no'] = this.purchaseNo;
    data['item_name'] = this.itemName;
    data['item_category_name'] = this.itemCategoryName;
    data['packing_type_name'] = this.packingTypeName;
    data['supplier_name'] = this.supplierName;
    data['supplier'] = this.supplier;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['purchase_cost'] = this.purchaseCost;
    data['sale_cost'] = this.saleCost;
    data['qty'] = this.qty;
    data['pack_qty'] = this.packQty;
    data['free_purchase'] = this.freePurchase;
    data['taxable'] = this.taxable;
    data['tax_rate'] = this.taxRate;
    data['tax_amount'] = this.taxAmount;
    data['discountable'] = this.discountable;
    data['expirable'] = this.expirable;
    data['discount_rate'] = this.discountRate;
    data['discount_amount'] = this.discountAmount;
    data['gross_amount'] = this.grossAmount;
    data['net_amount'] = this.netAmount;
    data['expiry_date_ad'] = this.expiryDateAd;
    data['expiry_date_bs'] = this.expiryDateBs;
    data['batch_no'] = this.batchNo;
    data['ref_transfer_detail'] = this.refTransferDetail;
    data['created_by'] = this.createdBy;
    data['purchase'] = this.purchase;
    data['item'] = this.item;
    data['item_category'] = this.itemCategory;
    data['packing_type'] = this.packingType;
    data['packing_type_detail'] = this.packingTypeDetail;
    data['ref_purchase_order_detail'] = this.refPurchaseOrderDetail;
    data['ref_purchase_detail'] = this.refPurchaseDetail;
    return data;
  }
}

class PuPackTypeCodes {
  int ? id;
  String? code;
  int ? location;
  Null ?purchaseOrderDetail;
  String ?locationCode;
  List<PackTypeDetailCodes>? packTypeDetailCodes;

  PuPackTypeCodes(
      {this.id,
        this.code,
        this.location,
        this.purchaseOrderDetail,
        this.locationCode,
        this.packTypeDetailCodes});

  PuPackTypeCodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    location = json['location'];
    purchaseOrderDetail = json['purchase_order_detail'];
    locationCode = json['location_code'];
    if (json['pack_type_detail_codes'] != null) {
      packTypeDetailCodes = <PackTypeDetailCodes>[];
      json['pack_type_detail_codes'].forEach((v) {
        packTypeDetailCodes!.add(new PackTypeDetailCodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['location'] = this.location;
    data['purchase_order_detail'] = this.purchaseOrderDetail;
    data['location_code'] = this.locationCode;
    if (this.packTypeDetailCodes != null) {
      data['pack_type_detail_codes'] =
          this.packTypeDetailCodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PackTypeDetailCodes {
  int ? id;
  String? code;

  PackTypeDetailCodes({this.id, this.code});

  PackTypeDetailCodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    return data;
  }
}
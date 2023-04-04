class Detail {
  Detail({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });
  late final int count;
  late final Null next;
  late final Null previous;
  late final List<Results> results;

  Detail.fromJson(Map<String, dynamic> json){
    count = json['count'];
    next = null;
    previous = null;
    results = List.from(json['results']).map((e)=>Results.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['next'] = next;
    _data['previous'] = previous;
    _data['results'] = results.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Results {
  Results({
    required this.id,
    required this.puPackTypeCodes,
    required this.createdDateAd,
    required this.createdDateBs,
    required this.deviceType,
    required this.appType,
    required this.purchaseCost,
    required this.saleCost,
    required this.qty,
    required this.packQty,
    required this.freePurchase,
    required this.taxable,
    required this.taxRate,
    required this.taxAmount,
    required this.discountable,
    required this.expirable,
    required this.actualCost,
    required this.discountRate,
    required this.discountAmount,
    required this.grossAmount,
    required this.netAmount,
    this.expiryDateAd,
    required this.expiryDateBs,
    required this.batchNo,
    required this.refTransferDetail,
    required this.refDepartmentTransferDetail,
    required this.refTaskOutput,
    required this.createdBy,
    required this.purchase,
    required this.item,
    required this.itemCategory,
    required this.packingType,
    required this.packingTypeDetail,
    this.refPurchaseOrderDetail,
    this.refPurchaseDetail,
  });
  late final int id;
  late final List<PuPackTypeCodes> puPackTypeCodes;
  late final String createdDateAd;
  late final String createdDateBs;
  late final int deviceType;
  late final int appType;
  late final String purchaseCost;
  late final String saleCost;
  late final String qty;
  late final String packQty;
  late final bool freePurchase;
  late final bool taxable;
  late final String taxRate;
  late final String taxAmount;
  late final bool discountable;
  late final bool expirable;
  late final String actualCost;
  late final String discountRate;
  late final String discountAmount;
  late final String grossAmount;
  late final String netAmount;
  late final Null expiryDateAd;
  late final String expiryDateBs;
  late final String batchNo;
  late final int refTransferDetail;
  late final int refDepartmentTransferDetail;
  late final int refTaskOutput;
  late final int createdBy;
  late final int purchase;
  late final int item;
  late final int itemCategory;
  late final int packingType;
  late final int packingTypeDetail;
  late final Null refPurchaseOrderDetail;
  late final Null refPurchaseDetail;

  Results.fromJson(Map<String, dynamic> json){
    id = json['id'];
    puPackTypeCodes = List.from(json['pu_pack_type_codes']).map((e)=>PuPackTypeCodes.fromJson(e)).toList();
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
    actualCost = json['actual_cost'];
    discountRate = json['discount_rate'];
    discountAmount = json['discount_amount'];
    grossAmount = json['gross_amount'];
    netAmount = json['net_amount'];
    expiryDateAd = null;
    expiryDateBs = json['expiry_date_bs'];
    batchNo = json['batch_no'];
    refTransferDetail = json['ref_transfer_detail'];
    refDepartmentTransferDetail = json['ref_department_transfer_detail'];
    refTaskOutput = json['ref_task_output'];
    createdBy = json['created_by'];
    purchase = json['purchase'];
    item = json['item'];
    itemCategory = json['item_category'];
    packingType = json['packing_type'];
    packingTypeDetail = json['packing_type_detail'];
    refPurchaseOrderDetail = null;
    refPurchaseDetail = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['pu_pack_type_codes'] = puPackTypeCodes.map((e)=>e.toJson()).toList();
    _data['created_date_ad'] = createdDateAd;
    _data['created_date_bs'] = createdDateBs;
    _data['device_type'] = deviceType;
    _data['app_type'] = appType;
    _data['purchase_cost'] = purchaseCost;
    _data['sale_cost'] = saleCost;
    _data['qty'] = qty;
    _data['pack_qty'] = packQty;
    _data['free_purchase'] = freePurchase;
    _data['taxable'] = taxable;
    _data['tax_rate'] = taxRate;
    _data['tax_amount'] = taxAmount;
    _data['discountable'] = discountable;
    _data['expirable'] = expirable;
    _data['actual_cost'] = actualCost;
    _data['discount_rate'] = discountRate;
    _data['discount_amount'] = discountAmount;
    _data['gross_amount'] = grossAmount;
    _data['net_amount'] = netAmount;
    _data['expiry_date_ad'] = expiryDateAd;
    _data['expiry_date_bs'] = expiryDateBs;
    _data['batch_no'] = batchNo;
    _data['ref_transfer_detail'] = refTransferDetail;
    _data['ref_department_transfer_detail'] = refDepartmentTransferDetail;
    _data['ref_task_output'] = refTaskOutput;
    _data['created_by'] = createdBy;
    _data['purchase'] = purchase;
    _data['item'] = item;
    _data['item_category'] = itemCategory;
    _data['packing_type'] = packingType;
    _data['packing_type_detail'] = packingTypeDetail;
    _data['ref_purchase_order_detail'] = refPurchaseOrderDetail;
    _data['ref_purchase_detail'] = refPurchaseDetail;
    return _data;
  }
}

class PuPackTypeCodes {
  PuPackTypeCodes({
    required this.id,
    required this.packTypeDetailCodes,
    required this.createdDateAd,
    required this.createdDateBs,
    required this.deviceType,
    required this.appType,
    required this.code,
    required this.qty,
    this.weight,
    required this.createdBy,
    required this.location,
    this.refPackingTypeCode,
  });
  late final int id;
  late final List<dynamic> packTypeDetailCodes;
  late final String createdDateAd;
  late final String createdDateBs;
  late final int deviceType;
  late final int appType;
  late final String code;
  late final String qty;
  late final Null weight;
  late final int createdBy;
  late final int location;
  late final Null refPackingTypeCode;

  PuPackTypeCodes.fromJson(Map<String, dynamic> json){
    id = json['id'];
    packTypeDetailCodes = List.castFrom<dynamic, dynamic>(json['pack_type_detail_codes']);
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    code = json['code'];
    qty = json['qty'];
    weight = null;
    createdBy = json['created_by'];
    location = json['location'];
    refPackingTypeCode = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['pack_type_detail_codes'] = packTypeDetailCodes;
    _data['created_date_ad'] = createdDateAd;
    _data['created_date_bs'] = createdDateBs;
    _data['device_type'] = deviceType;
    _data['app_type'] = appType;
    _data['code'] = code;
    _data['qty'] = qty;
    _data['weight'] = weight;
    _data['created_by'] = createdBy;
    _data['location'] = location;
    _data['ref_packing_type_code'] = refPackingTypeCode;
    return _data;
  }
}
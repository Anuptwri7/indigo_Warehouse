class DepartmentTransferPickupDetails {
  DepartmentTransferPickupDetails({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });
  late final int count;
  late final Null next;
  late final Null previous;
  late final List<Results> results;

  DepartmentTransferPickupDetails.fromJson(Map<String, dynamic> json){
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
    required this.itemName,
    required this.itemCategoryName,
    required this.itemUnitName,
    required this.batchNo,
    required this.departmentTransferPackingTypes,
    required this.itemIsSerializable,
    required this.pickedByUserName,
    required this.createdDateAd,
    required this.createdDateBs,
    required this.deviceType,
    required this.appType,
    required this.purchaseCost,
    required this.qty,
    required this.packQty,
    required this.expirable,
    this.expiryDateAd,
    required this.expiryDateBs,
    required this.netAmount,
    required this.isCancelled,
    required this.isPicked,
    required this.remarks,
    required this.createdBy,
    required this.departmentTransferMaster,
    required this.item,
    required this.itemCategory,
    required this.packingType,
    required this.packingTypeDetail,
    this.refDepartmentTransferDetail,
    required this.refPurchaseDetail,
    this.pickedBy,
  });
  late final int id;
  late final String itemName;
  late final String itemCategoryName;
  late final String itemUnitName;
  late final String batchNo;
  late final List<dynamic> departmentTransferPackingTypes;
  late final bool itemIsSerializable;
  late final String pickedByUserName;
  late final String createdDateAd;
  late final String createdDateBs;
  late final int deviceType;
  late final int appType;
  late final String purchaseCost;
  late final String qty;
  late final String packQty;
  late final bool expirable;
  late final Null expiryDateAd;
  late final String expiryDateBs;
  late final String netAmount;
  late final bool isCancelled;
  late final bool isPicked;
  late final String remarks;
  late final int createdBy;
  late final int departmentTransferMaster;
  late final int item;
  late final int itemCategory;
  late final int packingType;
  late final int packingTypeDetail;
  late final Null refDepartmentTransferDetail;
  late final int refPurchaseDetail;
  late final Null pickedBy;

  Results.fromJson(Map<String, dynamic> json){
    id = json['id'];
    itemName = json['item_name'];
    itemCategoryName = json['item_category_name'];
    itemUnitName = json['item_unit_name'];
    batchNo = json['batch_no'];
    departmentTransferPackingTypes = List.castFrom<dynamic, dynamic>(json['department_transfer_packing_types']);
    itemIsSerializable = json['item_is_serializable'];
    pickedByUserName = json['picked_by_user_name'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    purchaseCost = json['purchase_cost'];
    qty = json['qty'];
    packQty = json['pack_qty'];
    expirable = json['expirable'];
    expiryDateAd = null;
    expiryDateBs = json['expiry_date_bs'];
    netAmount = json['net_amount'];
    isCancelled = json['is_cancelled'];
    isPicked = json['is_picked'];
    remarks = json['remarks'];
    createdBy = json['created_by'];
    departmentTransferMaster = json['department_transfer_master'];
    item = json['item'];
    itemCategory = json['item_category'];
    packingType = json['packing_type'];
    packingTypeDetail = json['packing_type_detail'];
    refDepartmentTransferDetail = null;
    refPurchaseDetail = json['ref_purchase_detail'];
    pickedBy = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['item_name'] = itemName;
    _data['item_category_name'] = itemCategoryName;
    _data['item_unit_name'] = itemUnitName;
    _data['batch_no'] = batchNo;
    _data['department_transfer_packing_types'] = departmentTransferPackingTypes;
    _data['item_is_serializable'] = itemIsSerializable;
    _data['picked_by_user_name'] = pickedByUserName;
    _data['created_date_ad'] = createdDateAd;
    _data['created_date_bs'] = createdDateBs;
    _data['device_type'] = deviceType;
    _data['app_type'] = appType;
    _data['purchase_cost'] = purchaseCost;
    _data['qty'] = qty;
    _data['pack_qty'] = packQty;
    _data['expirable'] = expirable;
    _data['expiry_date_ad'] = expiryDateAd;
    _data['expiry_date_bs'] = expiryDateBs;
    _data['net_amount'] = netAmount;
    _data['is_cancelled'] = isCancelled;
    _data['is_picked'] = isPicked;
    _data['remarks'] = remarks;
    _data['created_by'] = createdBy;
    _data['department_transfer_master'] = departmentTransferMaster;
    _data['item'] = item;
    _data['item_category'] = itemCategory;
    _data['packing_type'] = packingType;
    _data['packing_type_detail'] = packingTypeDetail;
    _data['ref_department_transfer_detail'] = refDepartmentTransferDetail;
    _data['ref_purchase_detail'] = refPurchaseDetail;
    _data['picked_by'] = pickedBy;
    return _data;
  }
}
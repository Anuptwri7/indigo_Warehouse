class ReceiveDetail {
  int? id;
  List<DepartmentTransferDetails>? departmentTransferDetails;
  PackingType? fromDepartment;
  PackingType? toDepartment;
  String? createdByUserName;
  Null? receivedByUserName;
  String? approvedByUserName;
  String? createdDateAd;
  String? createdDateBs;
  int? deviceType;
  int? appType;
  String? transferNo;
  int? transferType;
  String? grandTotal;
  String? billNo;
  String? remarks;
  bool? isApproved;
  bool? isReceived;
  bool? isCancelled;
  bool? isPicked;
  int? createdBy;
  int? approvedBy;
  Null? receivedBy;

  ReceiveDetail(
      {this.id,
        this.departmentTransferDetails,
        this.fromDepartment,
        this.toDepartment,
        this.createdByUserName,
        this.receivedByUserName,
        this.approvedByUserName,
        this.createdDateAd,
        this.createdDateBs,
        this.deviceType,
        this.appType,
        this.transferNo,
        this.transferType,
        this.grandTotal,
        this.billNo,
        this.remarks,
        this.isApproved,
        this.isReceived,
        this.isCancelled,
        this.isPicked,
        this.createdBy,
        this.approvedBy,
        this.receivedBy});

  ReceiveDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['department_transfer_details'] != null) {
      departmentTransferDetails = <DepartmentTransferDetails>[];
      json['department_transfer_details'].forEach((v) {
        departmentTransferDetails!
            .add(new DepartmentTransferDetails.fromJson(v));
      });
    }
    fromDepartment = json['from_department'] != null
        ? new PackingType.fromJson(json['from_department'])
        : null;
    toDepartment = json['to_department'] != null
        ? new PackingType.fromJson(json['to_department'])
        : null;
    createdByUserName = json['created_by_user_name'];
    receivedByUserName = json['received_by_user_name'];
    approvedByUserName = json['approved_by_user_name'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    transferNo = json['transfer_no'];
    transferType = json['transfer_type'];
    grandTotal = json['grand_total'];
    billNo = json['bill_no'];
    remarks = json['remarks'];
    isApproved = json['is_approved'];
    isReceived = json['is_received'];
    isCancelled = json['is_cancelled'];
    isPicked = json['is_picked'];
    createdBy = json['created_by'];
    approvedBy = json['approved_by'];
    receivedBy = json['received_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.departmentTransferDetails != null) {
      data['department_transfer_details'] =
          this.departmentTransferDetails!.map((v) => v.toJson()).toList();
    }
    if (this.fromDepartment != null) {
      data['from_department'] = this.fromDepartment!.toJson();
    }
    if (this.toDepartment != null) {
      data['to_department'] = this.toDepartment!.toJson();
    }
    data['created_by_user_name'] = this.createdByUserName;
    data['received_by_user_name'] = this.receivedByUserName;
    data['approved_by_user_name'] = this.approvedByUserName;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['transfer_no'] = this.transferNo;
    data['transfer_type'] = this.transferType;
    data['grand_total'] = this.grandTotal;
    data['bill_no'] = this.billNo;
    data['remarks'] = this.remarks;
    data['is_approved'] = this.isApproved;
    data['is_received'] = this.isReceived;
    data['is_cancelled'] = this.isCancelled;
    data['is_picked'] = this.isPicked;
    data['created_by'] = this.createdBy;
    data['approved_by'] = this.approvedBy;
    data['received_by'] = this.receivedBy;
    return data;
  }
}

class DepartmentTransferDetails {
  int? id;
  String? itemName;
  String? itemCategoryName;
  bool? itemIsSerializable;
  String? itemUnitName;
  String? batchNo;
  List<DepartmentTransferPackingTypes>? departmentTransferPackingTypes;
  PackingType? packingType;
  PackingTypeDetail? packingTypeDetail;
  String? createdDateAd;
  String? createdDateBs;
  int? deviceType;
  int? appType;
  String? purchaseCost;
  String? qty;
  String? packQty;
  bool? expirable;
  Null? expiryDateAd;
  String? expiryDateBs;
  String? netAmount;
  bool? isCancelled;
  bool? isPicked;
  String? remarks;
  int? createdBy;
  int? departmentTransferMaster;
  int? item;
  int? itemCategory;
  int? refPurchaseDetail;
  int? pickedBy;

  DepartmentTransferDetails(
      {this.id,
        this.itemName,
        this.itemCategoryName,
        this.itemIsSerializable,
        this.itemUnitName,
        this.batchNo,
        this.departmentTransferPackingTypes,
        this.packingType,
        this.packingTypeDetail,
        this.createdDateAd,
        this.createdDateBs,
        this.deviceType,
        this.appType,
        this.purchaseCost,
        this.qty,
        this.packQty,
        this.expirable,
        this.expiryDateAd,
        this.expiryDateBs,
        this.netAmount,
        this.isCancelled,
        this.isPicked,
        this.remarks,
        this.createdBy,
        this.departmentTransferMaster,
        this.item,
        this.itemCategory,
        this.refPurchaseDetail,
        this.pickedBy});

  DepartmentTransferDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemCategoryName = json['item_category_name'];
    itemIsSerializable = json['item_is_serializable'];
    itemUnitName = json['item_unit_name'];
    batchNo = json['batch_no'];
    if (json['department_transfer_packing_types'] != null) {
      departmentTransferPackingTypes = <DepartmentTransferPackingTypes>[];
      json['department_transfer_packing_types'].forEach((v) {
        departmentTransferPackingTypes!
            .add(new DepartmentTransferPackingTypes.fromJson(v));
      });
    }
    packingType = json['packing_type'] != null
        ? new PackingType.fromJson(json['packing_type'])
        : null;
    packingTypeDetail = json['packing_type_detail'] != null
        ? new PackingTypeDetail.fromJson(json['packing_type_detail'])
        : null;
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    purchaseCost = json['purchase_cost'];
    qty = json['qty'];
    packQty = json['pack_qty'];
    expirable = json['expirable'];
    expiryDateAd = json['expiry_date_ad'];
    expiryDateBs = json['expiry_date_bs'];
    netAmount = json['net_amount'];
    isCancelled = json['is_cancelled'];
    isPicked = json['is_picked'];
    remarks = json['remarks'];
    createdBy = json['created_by'];
    departmentTransferMaster = json['department_transfer_master'];
    item = json['item'];
    itemCategory = json['item_category'];
    refPurchaseDetail = json['ref_purchase_detail'];
    pickedBy = json['picked_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_name'] = this.itemName;
    data['item_category_name'] = this.itemCategoryName;
    data['item_is_serializable'] = this.itemIsSerializable;
    data['item_unit_name'] = this.itemUnitName;
    data['batch_no'] = this.batchNo;
    if (this.departmentTransferPackingTypes != null) {
      data['department_transfer_packing_types'] =
          this.departmentTransferPackingTypes!.map((v) => v.toJson()).toList();
    }
    if (this.packingType != null) {
      data['packing_type'] = this.packingType!.toJson();
    }
    if (this.packingTypeDetail != null) {
      data['packing_type_detail'] = this.packingTypeDetail!.toJson();
    }
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['purchase_cost'] = this.purchaseCost;
    data['qty'] = this.qty;
    data['pack_qty'] = this.packQty;
    data['expirable'] = this.expirable;
    data['expiry_date_ad'] = this.expiryDateAd;
    data['expiry_date_bs'] = this.expiryDateBs;
    data['net_amount'] = this.netAmount;
    data['is_cancelled'] = this.isCancelled;
    data['is_picked'] = this.isPicked;
    data['remarks'] = this.remarks;
    data['created_by'] = this.createdBy;
    data['department_transfer_master'] = this.departmentTransferMaster;
    data['item'] = this.item;
    data['item_category'] = this.itemCategory;
    data['ref_purchase_detail'] = this.refPurchaseDetail;
    data['picked_by'] = this.pickedBy;
    return data;
  }
}

class DepartmentTransferPackingTypes {
  int? id;
  String? locationCode;
  int? location;
  String? code;
  String? qty;
  Null? saleDetail;
  int? packingTypeCode;
  List<SalePackingTypeDetailCode>? salePackingTypeDetailCode;

  DepartmentTransferPackingTypes(
      {this.id,
        this.locationCode,
        this.location,
        this.code,
        this.qty,
        this.saleDetail,
        this.packingTypeCode,
        this.salePackingTypeDetailCode});

  DepartmentTransferPackingTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationCode = json['location_code'];
    location = json['location'];
    code = json['code'];
    qty = json['qty'];
    saleDetail = json['sale_detail'];
    packingTypeCode = json['packing_type_code'];
    if (json['sale_packing_type_detail_code'] != null) {
      salePackingTypeDetailCode = <SalePackingTypeDetailCode>[];
      json['sale_packing_type_detail_code'].forEach((v) {
        salePackingTypeDetailCode!
            .add(new SalePackingTypeDetailCode.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location_code'] = this.locationCode;
    data['location'] = this.location;
    data['code'] = this.code;
    data['qty'] = this.qty;
    data['sale_detail'] = this.saleDetail;
    data['packing_type_code'] = this.packingTypeCode;
    if (this.salePackingTypeDetailCode != null) {
      data['sale_packing_type_detail_code'] =
          this.salePackingTypeDetailCode!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalePackingTypeDetailCode {
  int? id;
  int? packingTypeDetailCode;
  String? code;

  SalePackingTypeDetailCode({this.id, this.packingTypeDetailCode, this.code});

  SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packingTypeDetailCode = json['packing_type_detail_code'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['packing_type_detail_code'] = this.packingTypeDetailCode;
    data['code'] = this.code;
    return data;
  }
}

class PackingType {
  int? id;
  String? name;

  PackingType({this.id, this.name});

  PackingType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class PackingTypeDetail {
  int? id;
  double? packQty;

  PackingTypeDetail({this.id, this.packQty});

  PackingTypeDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    packQty = json['pack_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pack_qty'] = this.packQty;
    return data;
  }
}
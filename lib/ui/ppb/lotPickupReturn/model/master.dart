class LotPickupReturn {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  LotPickupReturn({this.count, this.next, this.previous, this.results});

  LotPickupReturn.fromJson(Map<String, dynamic> json) {
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
  int? id;
  List<LotDetails>? lotDetails;
  String? createdDateAd;
  String? createdDateBs;
  int? deviceType;
  int? appType;
  int? status;
  String? lotNo;
  String? name;
  String? expectedOutputQty;
  String? remarks;
  bool? picked;
  bool? isCancelled;
  String? mouldTemperature;
  String? connectionTemperature;
  String? extruderTemperature;
  int? createdBy;
  int? taskMain;

  Results(
      {this.id,
        this.lotDetails,
        this.createdDateAd,
        this.createdDateBs,
        this.deviceType,
        this.appType,
        this.status,
        this.lotNo,
        this.name,
        this.expectedOutputQty,
        this.remarks,
        this.picked,
        this.isCancelled,
        this.mouldTemperature,
        this.connectionTemperature,
        this.extruderTemperature,
        this.createdBy,
        this.taskMain});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['lot_details'] != null) {
      lotDetails = <LotDetails>[];
      json['lot_details'].forEach((v) {
        lotDetails!.add(new LotDetails.fromJson(v));
      });
    }
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    status = json['status'];
    lotNo = json['lot_no'];
    name = json['name'];
    expectedOutputQty = json['expected_output_qty'];
    remarks = json['remarks'];
    picked = json['picked'];
    isCancelled = json['is_cancelled'];
    mouldTemperature = json['mould_temperature'];
    connectionTemperature = json['connection_temperature'];
    extruderTemperature = json['extruder_temperature'];
    createdBy = json['created_by'];
    taskMain = json['task_main'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.lotDetails != null) {
      data['lot_details'] = this.lotDetails!.map((v) => v.toJson()).toList();
    }
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['status'] = this.status;
    data['lot_no'] = this.lotNo;
    data['name'] = this.name;
    data['expected_output_qty'] = this.expectedOutputQty;
    data['remarks'] = this.remarks;
    data['picked'] = this.picked;
    data['is_cancelled'] = this.isCancelled;
    data['mould_temperature'] = this.mouldTemperature;
    data['connection_temperature'] = this.connectionTemperature;
    data['extruder_temperature'] = this.extruderTemperature;
    data['created_by'] = this.createdBy;
    data['task_main'] = this.taskMain;
    return data;
  }
}

class LotDetails {
  int? id;
  List<TaskLotPackingTypeCodes>? taskLotPackingTypeCodes;
  String? itemName;
  Null? itemCategoryName;
  bool? itemIsSerializable;
  String? createdDateAd;
  String? createdDateBs;
  int? deviceType;
  int? appType;
  String? qty;
  bool? picked;
  bool? isCancelled;
  int? createdBy;
  int? lotMain;
  int? taskDetail;
  int? item;
  int? pickedBy;
  int? purchaseDetail;

  LotDetails(
      {this.id,
        this.taskLotPackingTypeCodes,
        this.itemName,
        this.itemCategoryName,
        this.itemIsSerializable,
        this.createdDateAd,
        this.createdDateBs,
        this.deviceType,
        this.appType,
        this.qty,
        this.picked,
        this.isCancelled,
        this.createdBy,
        this.lotMain,
        this.taskDetail,
        this.item,
        this.pickedBy,
        this.purchaseDetail});

  LotDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['task_lot_packing_type_codes'] != null) {
      taskLotPackingTypeCodes = <TaskLotPackingTypeCodes>[];
      json['task_lot_packing_type_codes'].forEach((v) {
        taskLotPackingTypeCodes!.add(new TaskLotPackingTypeCodes.fromJson(v));
      });
    }
    itemName = json['item_name'];
    itemCategoryName = json['item_category_name'];
    itemIsSerializable = json['item_is_serializable'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    qty = json['qty'];
    picked = json['picked'];
    isCancelled = json['is_cancelled'];
    createdBy = json['created_by'];
    lotMain = json['lot_main'];
    taskDetail = json['task_detail'];
    item = json['item'];
    pickedBy = json['picked_by'];
    purchaseDetail = json['purchase_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.taskLotPackingTypeCodes != null) {
      data['task_lot_packing_type_codes'] =
          this.taskLotPackingTypeCodes!.map((v) => v.toJson()).toList();
    }
    data['item_name'] = this.itemName;
    data['item_category_name'] = this.itemCategoryName;
    data['item_is_serializable'] = this.itemIsSerializable;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['qty'] = this.qty;
    data['picked'] = this.picked;
    data['is_cancelled'] = this.isCancelled;
    data['created_by'] = this.createdBy;
    data['lot_main'] = this.lotMain;
    data['task_detail'] = this.taskDetail;
    data['item'] = this.item;
    data['picked_by'] = this.pickedBy;
    data['purchase_detail'] = this.purchaseDetail;
    return data;
  }
}

class TaskLotPackingTypeCodes {
  int? id;
  List<SalePackingTypeDetailCode>? salePackingTypeDetailCode;
  String? code;
  double? remainingPickedQty;
  String? qty;
  int? packingTypeCode;
  Null? saleDetail;
  Null? customerOrderDetail;
  Null? chalanDetail;
  Null? transferDetail;
  Null? departmentTransferDetail;
  int? taskLotDetail;
  Null? refSalePackingTypeCode;

  TaskLotPackingTypeCodes(
      {this.id,
        this.salePackingTypeDetailCode,
        this.code,
        this.remainingPickedQty,
        this.qty,
        this.packingTypeCode,
        this.saleDetail,
        this.customerOrderDetail,
        this.chalanDetail,
        this.transferDetail,
        this.departmentTransferDetail,
        this.taskLotDetail,
        this.refSalePackingTypeCode});

  TaskLotPackingTypeCodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['sale_packing_type_detail_code'] != null) {
      salePackingTypeDetailCode = <SalePackingTypeDetailCode>[];
      json['sale_packing_type_detail_code'].forEach((v) {
        salePackingTypeDetailCode!
            .add(new SalePackingTypeDetailCode.fromJson(v));
      });
    }
    code = json['code'];
    remainingPickedQty = json['remaining_picked_qty'];
    qty = json['qty'];
    packingTypeCode = json['packing_type_code'];
    saleDetail = json['sale_detail'];
    customerOrderDetail = json['customer_order_detail'];
    chalanDetail = json['chalan_detail'];
    transferDetail = json['transfer_detail'];
    departmentTransferDetail = json['department_transfer_detail'];
    taskLotDetail = json['task_lot_detail'];
    refSalePackingTypeCode = json['ref_sale_packing_type_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.salePackingTypeDetailCode != null) {
      data['sale_packing_type_detail_code'] =
          this.salePackingTypeDetailCode!.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['remaining_picked_qty'] = this.remainingPickedQty;
    data['qty'] = this.qty;
    data['packing_type_code'] = this.packingTypeCode;
    data['sale_detail'] = this.saleDetail;
    data['customer_order_detail'] = this.customerOrderDetail;
    data['chalan_detail'] = this.chalanDetail;
    data['transfer_detail'] = this.transferDetail;
    data['department_transfer_detail'] = this.departmentTransferDetail;
    data['task_lot_detail'] = this.taskLotDetail;
    data['ref_sale_packing_type_code'] = this.refSalePackingTypeCode;
    return data;
  }
}

class SalePackingTypeDetailCode {
  int? id;
  String? code;
  int? salePackingTypeCode;
  int? packingTypeDetailCode;
  Null? refSalePackingTypeDetailCode;

  SalePackingTypeDetailCode(
      {this.id,
        this.code,
        this.salePackingTypeCode,
        this.packingTypeDetailCode,
        this.refSalePackingTypeDetailCode});

  SalePackingTypeDetailCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    salePackingTypeCode = json['sale_packing_type_code'];
    packingTypeDetailCode = json['packing_type_detail_code'];
    refSalePackingTypeDetailCode = json['ref_sale_packing_type_detail_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['sale_packing_type_code'] = this.salePackingTypeCode;
    data['packing_type_detail_code'] = this.packingTypeDetailCode;
    data['ref_sale_packing_type_detail_code'] =
        this.refSalePackingTypeDetailCode;
    return data;
  }
}
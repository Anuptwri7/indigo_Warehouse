class DropMatserListings {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  DropMatserListings({this.count, this.next, this.previous, this.results});

  DropMatserListings.fromJson(Map<String, dynamic> json) {
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
  String? createdByUsername;
  FromDepartment? fromDepartment;
  FromDepartment? toDepartment;
  bool? dropped;
  String? createdDateAd;
  String? createdDateBs;
  int? deviceType;
  int? appType;
  String? purchaseNo;
  int? purchaseType;
  int? payType;
  String? subTotal;
  String? totalDiscount;
  String? discountRate;
  String? totalDiscountableAmount;
  String? totalTaxableAmount;
  String? totalNonTaxableAmount;
  String? totalTax;
  String? grandTotal;
  String? roundOffAmount;
  String? billNo;
  String? billDateAd;
  String? billDateBs;
  String? chalanNo;
  String? dueDateAd;
  String? dueDateBs;
  String? remarks;
  int? refDepartmentTransferMaster;
  int? refTaskLotMain;
  int? createdBy;
  int? department;
  int? discountScheme;
  int? supplier;
  int? fiscalSessionAd;
  int? fiscalSessionBs;
  int? refPurchase;
  int? refPurchaseOrder;

  Results(
      {this.id,
        this.createdByUsername,
        this.fromDepartment,
        this.toDepartment,
        this.dropped,
        this.createdDateAd,
        this.createdDateBs,
        this.deviceType,
        this.appType,
        this.purchaseNo,
        this.purchaseType,
        this.payType,
        this.subTotal,
        this.totalDiscount,
        this.discountRate,
        this.totalDiscountableAmount,
        this.totalTaxableAmount,
        this.totalNonTaxableAmount,
        this.totalTax,
        this.grandTotal,
        this.roundOffAmount,
        this.billNo,
        this.billDateAd,
        this.billDateBs,
        this.chalanNo,
        this.dueDateAd,
        this.dueDateBs,
        this.remarks,
        this.refDepartmentTransferMaster,
        this.refTaskLotMain,
        this.createdBy,
        this.department,
        this.discountScheme,
        this.supplier,
        this.fiscalSessionAd,
        this.fiscalSessionBs,
        this.refPurchase,
        this.refPurchaseOrder});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdByUsername = json['created_by_username'];
    fromDepartment = json['from_department'] != null
        ? new FromDepartment.fromJson(json['from_department'])
        : null;
    toDepartment = json['to_department'] != null
        ? new FromDepartment.fromJson(json['to_department'])
        : null;
    dropped = json['dropped'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    purchaseNo = json['purchase_no'];
    purchaseType = json['purchase_type'];
    payType = json['pay_type'];
    subTotal = json['sub_total'];
    totalDiscount = json['total_discount'];
    discountRate = json['discount_rate'];
    totalDiscountableAmount = json['total_discountable_amount'];
    totalTaxableAmount = json['total_taxable_amount'];
    totalNonTaxableAmount = json['total_non_taxable_amount'];
    totalTax = json['total_tax'];
    grandTotal = json['grand_total'];
    roundOffAmount = json['round_off_amount'];
    billNo = json['bill_no'];
    billDateAd = json['bill_date_ad'];
    billDateBs = json['bill_date_bs'];
    chalanNo = json['chalan_no'];
    dueDateAd = json['due_date_ad'];
    dueDateBs = json['due_date_bs'];
    remarks = json['remarks'];
    refDepartmentTransferMaster = json['ref_department_transfer_master'];
    refTaskLotMain = json['ref_task_lot_main'];
    createdBy = json['created_by'];
    department = json['department'];
    discountScheme = json['discount_scheme'];
    supplier = json['supplier'];
    fiscalSessionAd = json['fiscal_session_ad'];
    fiscalSessionBs = json['fiscal_session_bs'];
    refPurchase = json['ref_purchase'];
    refPurchaseOrder = json['ref_purchase_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by_username'] = this.createdByUsername;
    if (this.fromDepartment != null) {
      data['from_department'] = this.fromDepartment!.toJson();
    }
    if (this.toDepartment != null) {
      data['to_department'] = this.toDepartment!.toJson();
    }
    data['dropped'] = this.dropped;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['purchase_no'] = this.purchaseNo;
    data['purchase_type'] = this.purchaseType;
    data['pay_type'] = this.payType;
    data['sub_total'] = this.subTotal;
    data['total_discount'] = this.totalDiscount;
    data['discount_rate'] = this.discountRate;
    data['total_discountable_amount'] = this.totalDiscountableAmount;
    data['total_taxable_amount'] = this.totalTaxableAmount;
    data['total_non_taxable_amount'] = this.totalNonTaxableAmount;
    data['total_tax'] = this.totalTax;
    data['grand_total'] = this.grandTotal;
    data['round_off_amount'] = this.roundOffAmount;
    data['bill_no'] = this.billNo;
    data['bill_date_ad'] = this.billDateAd;
    data['bill_date_bs'] = this.billDateBs;
    data['chalan_no'] = this.chalanNo;
    data['due_date_ad'] = this.dueDateAd;
    data['due_date_bs'] = this.dueDateBs;
    data['remarks'] = this.remarks;
    data['ref_department_transfer_master'] = this.refDepartmentTransferMaster;
    data['ref_task_lot_main'] = this.refTaskLotMain;
    data['created_by'] = this.createdBy;
    data['department'] = this.department;
    data['discount_scheme'] = this.discountScheme;
    data['supplier'] = this.supplier;
    data['fiscal_session_ad'] = this.fiscalSessionAd;
    data['fiscal_session_bs'] = this.fiscalSessionBs;
    data['ref_purchase'] = this.refPurchase;
    data['ref_purchase_order'] = this.refPurchaseOrder;
    return data;
  }
}

class FromDepartment {
  int? id;
  String? name;

  FromDepartment({this.id, this.name});

  FromDepartment.fromJson(Map<String, dynamic> json) {
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
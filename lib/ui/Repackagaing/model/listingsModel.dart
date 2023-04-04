class Listings {
  Listings({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });
  late final int count;
  late final Null next;
  late final Null previous;
  late final List<Results> results;

  Listings.fromJson(Map<String, dynamic> json){
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
    required this.saleAdditionalCharges,
    required this.paymentDetails,
    required this.customerFirstName,
    required this.customerMiddleName,
    required this.customerLastName,
    required this.customerAddress,
    required this.customerPhoneNo,
    required this.createdByUserName,
    required this.saleTypeDisplay,
    required this.payTypeDisplay,
    required this.orderNo,
    required this.createdDateAd,
    required this.createdDateBs,
    required this.deviceType,
    required this.appType,
    required this.saleNo,
    required this.saleType,
    required this.subTotal,
    required this.discountRate,
    required this.totalDiscountableAmount,
    required this.totalTaxableAmount,
    required this.totalNonTaxableAmount,
    required this.totalDiscount,
    required this.totalTax,
    required this.grandTotal,
    required this.payType,
    required this.refBy,
    required this.remarks,
    required this.returnDropped,
    required this.syncedWithIrd,
    required this.realTimeUpload,
    required this.active,
    required this.createdBy,
    required this.department,
    this.discountScheme,
    required this.customer,
    required this.fiscalSessionAd,
    required this.fiscalSessionBs,
    this.refSaleMaster,
    required this.refOrderMaster,
    this.refChalanMaster,
  });
  late final int id;
  late final List<dynamic> saleAdditionalCharges;
  late final List<dynamic> paymentDetails;
  late final String customerFirstName;
  late final String customerMiddleName;
  late final String customerLastName;
  late final String customerAddress;
  late final String customerPhoneNo;
  late final String createdByUserName;
  late final String saleTypeDisplay;
  late final String payTypeDisplay;
  late final String orderNo;
  late final String createdDateAd;
  late final String createdDateBs;
  late final int deviceType;
  late final int appType;
  late final String saleNo;
  late final int saleType;
  late final String subTotal;
  late final String discountRate;
  late final String totalDiscountableAmount;
  late final String totalTaxableAmount;
  late final String totalNonTaxableAmount;
  late final String totalDiscount;
  late final String totalTax;
  late final String grandTotal;
  late final int payType;
  late final String refBy;
  late final String remarks;
  late final bool returnDropped;
  late final bool syncedWithIrd;
  late final bool realTimeUpload;
  late final bool active;
  late final int createdBy;
  late final int department;
  late final Null discountScheme;
  late final int customer;
  late final int fiscalSessionAd;
  late final int fiscalSessionBs;
  late final Null refSaleMaster;
  late final int refOrderMaster;
  late final Null refChalanMaster;

  Results.fromJson(Map<String, dynamic> json){
    id = json['id'];
    saleAdditionalCharges = List.castFrom<dynamic, dynamic>(json['sale_additional_charges']);
    paymentDetails = List.castFrom<dynamic, dynamic>(json['payment_details']);
    customerFirstName = json['customer_first_name'];
    customerMiddleName = json['customer_middle_name'];
    customerLastName = json['customer_last_name'];
    customerAddress = json['customer_address'];
    customerPhoneNo = json['customer_phone_no'];
    createdByUserName = json['created_by_user_name'];
    saleTypeDisplay = json['sale_type_display'];
    payTypeDisplay = json['pay_type_display'];
    orderNo = json['order_no'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    saleNo = json['sale_no'];
    saleType = json['sale_type'];
    subTotal = json['sub_total'];
    discountRate = json['discount_rate'];
    totalDiscountableAmount = json['total_discountable_amount'];
    totalTaxableAmount = json['total_taxable_amount'];
    totalNonTaxableAmount = json['total_non_taxable_amount'];
    totalDiscount = json['total_discount'];
    totalTax = json['total_tax'];
    grandTotal = json['grand_total'];
    payType = json['pay_type'];
    refBy = json['ref_by'];
    remarks = json['remarks'];
    returnDropped = json['return_dropped'];
    syncedWithIrd = json['synced_with_ird'];
    realTimeUpload = json['real_time_upload'];
    active = json['active'];
    createdBy = json['created_by'];
    department = json['department'];
    discountScheme = null;
    customer = json['customer'];
    fiscalSessionAd = json['fiscal_session_ad'];
    fiscalSessionBs = json['fiscal_session_bs'];
    refSaleMaster = null;
    refOrderMaster = json['ref_order_master'];
    refChalanMaster = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['sale_additional_charges'] = saleAdditionalCharges;
    _data['payment_details'] = paymentDetails;
    _data['customer_first_name'] = customerFirstName;
    _data['customer_middle_name'] = customerMiddleName;
    _data['customer_last_name'] = customerLastName;
    _data['customer_address'] = customerAddress;
    _data['customer_phone_no'] = customerPhoneNo;
    _data['created_by_user_name'] = createdByUserName;
    _data['sale_type_display'] = saleTypeDisplay;
    _data['pay_type_display'] = payTypeDisplay;
    _data['order_no'] = orderNo;
    _data['created_date_ad'] = createdDateAd;
    _data['created_date_bs'] = createdDateBs;
    _data['device_type'] = deviceType;
    _data['app_type'] = appType;
    _data['sale_no'] = saleNo;
    _data['sale_type'] = saleType;
    _data['sub_total'] = subTotal;
    _data['discount_rate'] = discountRate;
    _data['total_discountable_amount'] = totalDiscountableAmount;
    _data['total_taxable_amount'] = totalTaxableAmount;
    _data['total_non_taxable_amount'] = totalNonTaxableAmount;
    _data['total_discount'] = totalDiscount;
    _data['total_tax'] = totalTax;
    _data['grand_total'] = grandTotal;
    _data['pay_type'] = payType;
    _data['ref_by'] = refBy;
    _data['remarks'] = remarks;
    _data['return_dropped'] = returnDropped;
    _data['synced_with_ird'] = syncedWithIrd;
    _data['real_time_upload'] = realTimeUpload;
    _data['active'] = active;
    _data['created_by'] = createdBy;
    _data['department'] = department;
    _data['discount_scheme'] = discountScheme;
    _data['customer'] = customer;
    _data['fiscal_session_ad'] = fiscalSessionAd;
    _data['fiscal_session_bs'] = fiscalSessionBs;
    _data['ref_sale_master'] = refSaleMaster;
    _data['ref_order_master'] = refOrderMaster;
    _data['ref_chalan_master'] = refChalanMaster;
    return _data;
  }
}
class RepackagingToSendModel {
  RepackagingToSendModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });
  late final int count;
  late final Null next;
  late final Null previous;
  late final List<Results> results;

  RepackagingToSendModel.fromJson(Map<String, dynamic> json){
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
    required this.item,
    required this.itemName,
    required this.itemCategoryName,
    required this.batchNo,
    required this.salePackingTypeCode,
  });
  late final int id;
  late final int item;
  late final String itemName;
  late final String itemCategoryName;
  late final String batchNo;
  late final List<SalePackingTypeCode> salePackingTypeCode;

  Results.fromJson(Map<String, dynamic> json){
    id = json['id'];
    item = json['item'];
    itemName = json['item_name'];
    itemCategoryName = json['item_category_name'];
    batchNo = json['batch_no'];
    salePackingTypeCode = List.from(json['sale_packing_type_code']).map((e)=>SalePackingTypeCode.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['item'] = item;
    _data['item_name'] = itemName;
    _data['item_category_name'] = itemCategoryName;
    _data['batch_no'] = batchNo;
    _data['sale_packing_type_code'] = salePackingTypeCode.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SalePackingTypeCode {
  SalePackingTypeCode({
    required this.id,
    required this.code,
    required this.packingTypeCode,
    required this.customerOrderDetail,
    this.refSalePackingTypeCode,
    required this.salePackingTypeDetailCode,
    required this.locationCode,
  });
  late final int id;
  late final String code;
  late final int packingTypeCode;
  late final int customerOrderDetail;
  late final Null refSalePackingTypeCode;
  late final List<dynamic> salePackingTypeDetailCode;
  late final String locationCode;

  SalePackingTypeCode.fromJson(Map<String, dynamic> json){
    id = json['id'];
    code = json['code'];
    packingTypeCode = json['packing_type_code'];
    customerOrderDetail = json['customer_order_detail'];
    refSalePackingTypeCode = null;
    salePackingTypeDetailCode = List.castFrom<dynamic, dynamic>(json['sale_packing_type_detail_code']);
    locationCode = json['location_code'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['code'] = code;
    _data['packing_type_code'] = packingTypeCode;
    _data['customer_order_detail'] = customerOrderDetail;
    _data['ref_sale_packing_type_code'] = refSalePackingTypeCode;
    _data['sale_packing_type_detail_code'] = salePackingTypeDetailCode;
    _data['location_code'] = locationCode;
    return _data;
  }
}
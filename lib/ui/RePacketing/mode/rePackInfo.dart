class RePackInfo {
  RePackInfo({
    required this.id,
    required this.code,
    required this.locationCode,
    required this.itemName,
    required this.batchNo,
    this.supplierName,
    required this.packTypeDetailCodes,
    required this.qty,
    this.lotNo,
    this.taskNo,
    required this.remainingPackQty,
  });
  late final int id;
  late final String code;
  late final String locationCode;
  late final String itemName;
  late final String batchNo;
  late final Null supplierName;
  late final List<dynamic> packTypeDetailCodes;
  late final String qty;
  late final Null lotNo;
  late final Null taskNo;
  late final String remainingPackQty;

  RePackInfo.fromJson(Map<String, dynamic> json){
    id = json['id'];
    code = json['code'];
    locationCode = json['location_code'];
    itemName = json['item_name'];
    batchNo = json['batch_no'];
    supplierName = null;
    packTypeDetailCodes = List.castFrom<dynamic, dynamic>(json['pack_type_detail_codes']);
    qty = json['qty'];
    lotNo = null;
    taskNo = null;
    remainingPackQty = json['remaining_pack_qty'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['code'] = code;
    _data['location_code'] = locationCode;
    _data['item_name'] = itemName;
    _data['batch_no'] = batchNo;
    _data['supplier_name'] = supplierName;
    _data['pack_type_detail_codes'] = packTypeDetailCodes;
    _data['qty'] = qty;
    _data['lot_no'] = lotNo;
    _data['task_no'] = taskNo;
    _data['remaining_pack_qty'] = remainingPackQty;
    return _data;
  }
}
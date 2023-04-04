class Packinfo {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  Packinfo({this.count, this.next, this.previous, this.results});

  Packinfo.fromJson(Map<String, dynamic> json) {
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
  String? department;
  String? code;
  String? locationCode;
  String? itemName;
  String? batchNo;
  int? purchaseDetail;
  int? purchaseOrderDetail;
  String? supplierName;
  List<PackTypeDetailCodes>? packTypeDetailCodes;
  String? qty;
  Null? lotNo;
  Null? taskNo;
  String? remainingPackQty;

  Results(
      {this.id,
        this.department,
        this.code,
        this.locationCode,
        this.itemName,
        this.batchNo,
        this.purchaseDetail,
        this.purchaseOrderDetail,
        this.supplierName,
        this.packTypeDetailCodes,
        this.qty,
        this.lotNo,
        this.taskNo,
        this.remainingPackQty});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    department = json['department'];
    code = json['code'];
    locationCode = json['location_code'];
    itemName = json['item_name'];
    batchNo = json['batch_no'];
    purchaseDetail = json['purchase_detail'];
    purchaseOrderDetail = json['purchase_order_detail'];
    supplierName = json['supplier_name'];
    if (json['pack_type_detail_codes'] != null) {
      packTypeDetailCodes = <PackTypeDetailCodes>[];
      json['pack_type_detail_codes'].forEach((v) {
        packTypeDetailCodes!.add(new PackTypeDetailCodes.fromJson(v));
      });
    }
    qty = json['qty'];
    lotNo = json['lot_no'];
    taskNo = json['task_no'];
    remainingPackQty = json['remaining_pack_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department'] = this.department;
    data['code'] = this.code;
    data['location_code'] = this.locationCode;
    data['item_name'] = this.itemName;
    data['batch_no'] = this.batchNo;
    data['purchase_detail'] = this.purchaseDetail;
    data['purchase_order_detail'] = this.purchaseOrderDetail;
    data['supplier_name'] = this.supplierName;
    if (this.packTypeDetailCodes != null) {
      data['pack_type_detail_codes'] =
          this.packTypeDetailCodes!.map((v) => v.toJson()).toList();
    }
    data['qty'] = this.qty;
    data['lot_no'] = this.lotNo;
    data['task_no'] = this.taskNo;
    data['remaining_pack_qty'] = this.remainingPackQty;
    return data;
  }
}

class PackTypeDetailCodes {
  int? id;
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
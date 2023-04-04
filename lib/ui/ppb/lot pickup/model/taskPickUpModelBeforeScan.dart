class TaskPickupModelTask {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  TaskPickupModelTask({this.count, this.next, this.previous, this.results});

  TaskPickupModelTask.fromJson(Map<String, dynamic> json) {
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
  String? code;
  int? purchaseDetail;
  double? qty;
  String? locationCode;
  double? remainingQty;
  String? batchNo;
  int? itemId;
  String? itemName;

  Results(
      {this.id,
        this.code,
        this.purchaseDetail,
        this.qty,
        this.locationCode,
        this.remainingQty,
        this.batchNo,
        this.itemId,
        this.itemName});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    purchaseDetail = json['purchase_detail'];
    qty = json['qty'];
    locationCode = json['location_code'];
    remainingQty = json['remaining_qty'];
    batchNo = json['batch_no'];
    itemId = json['item_id'];
    itemName = json['item_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['purchase_detail'] = this.purchaseDetail;
    data['qty'] = this.qty;
    data['location_code'] = this.locationCode;
    data['remaining_qty'] = this.remainingQty;
    data['batch_no'] = this.batchNo;
    data['item_id'] = this.itemId;
    data['item_name'] = this.itemName;
    return data;
  }
}
class TaskPickupAdditionalModel {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  TaskPickupAdditionalModel(
      {this.count, this.next, this.previous, this.results});

  TaskPickupAdditionalModel.fromJson(Map<String, dynamic> json) {
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
  // List<Null> taskLotPackingTypeCodes;
  String? itemName;
  String? itemCode;
  String? itemCategoryName;
  String? itemUnitName;
  String? batchNo;
  bool? itemIsSerializable;
  String ?pickedByUserName;
  String? createdDateAd;
  String? createdDateBs;
  double? qty;
  bool? picked;
  bool? isCancelled;
  int? createdBy;
  int? lotMain;
  int? taskDetail;
  int? item;
  int? pickedBy;
  int? purchaseDetail;

  Results(
      {this.id,
        // this.taskLotPackingTypeCodes,
        this.itemName,
        this.itemCode,
        this.itemCategoryName,
        this.itemUnitName,
        this.batchNo,
        this.itemIsSerializable,
        this.pickedByUserName,
        this.createdDateAd,
        this.createdDateBs,
        this.qty,
        this.picked,
        this.isCancelled,
        this.createdBy,
        this.lotMain,
        this.taskDetail,
        this.item,
        this.pickedBy,
        this.purchaseDetail});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    itemName = json['item_name'];
    itemCode = json['item_code'];
    itemCategoryName = json['item_category_name'];
    itemUnitName = json['item_unit_name'];
    batchNo = json['batch_no'];
    itemIsSerializable = json['item_is_serializable'];
    pickedByUserName = json['picked_by_user_name'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    qty = double.parse(json['qty']);
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

    data['item_name'] = this.itemName;
    data['item_code'] = this.itemCode;
    data['item_category_name'] = this.itemCategoryName;
    data['item_unit_name'] = this.itemUnitName;
    data['batch_no'] = this.batchNo;
    data['item_is_serializable'] = this.itemIsSerializable;
    data['picked_by_user_name'] = this.pickedByUserName;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
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
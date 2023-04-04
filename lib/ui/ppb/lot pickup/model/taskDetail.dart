class TaskDetail {
  int? count;
  Null ?next;
  Null ?previous;
  List<Results>? results;

  TaskDetail({this.count, this.next, this.previous, this.results});

  TaskDetail.fromJson(Map<String, dynamic> json) {
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
  String? createdByUserName;
  String? taskNo;
  String? statusDisplay;
  OutputItem? outputItem;
  double? remainingLotQty;
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
  int ?createdBy;
  int? taskMain;

  Results(
      {this.id,
        this.createdByUserName,
        this.taskNo,
        this.statusDisplay,
        this.outputItem,
        this.remainingLotQty,
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
        this.createdBy,
        this.taskMain});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdByUserName = json['created_by_user_name'];
    taskNo = json['task_no'];
    statusDisplay = json['status_display'];
    outputItem = json['output_item'] != null
        ? new OutputItem.fromJson(json['output_item'])
        : null;
    remainingLotQty = json['remaining_lot_qty'];
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
    createdBy = json['created_by'];
    taskMain = json['task_main'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by_user_name'] = this.createdByUserName;
    data['task_no'] = this.taskNo;
    data['status_display'] = this.statusDisplay;
    if (this.outputItem != null) {
      data['output_item'] = this.outputItem!.toJson();
    }
    data['remaining_lot_qty'] = this.remainingLotQty;
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
    data['created_by'] = this.createdBy;
    data['task_main'] = this.taskMain;
    return data;
  }
}

class OutputItem {
  int? id;
  String? name;
  String? code;
  bool? isSerializable;

  OutputItem({this.id, this.name, this.code, this.isSerializable});

  OutputItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    isSerializable = json['is_serializable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['is_serializable'] = this.isSerializable;
    return data;
  }
}
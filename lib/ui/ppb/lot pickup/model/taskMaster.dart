class TaskMaster {
  int? count;
  String? next;
  Null? previous;
  List<Results>? results;

  TaskMaster({this.count, this.next, this.previous, this.results});

  TaskMaster.fromJson(Map<String, dynamic> json) {
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
  List<TaskDetails> ?taskDetails;
  String? createdByUserName;
  String? departmentName;
  String? departmentCode;
  String? approvedByUserName;
  String? statusDisplay;
  OutputItem? outputItem;
  String? remainingTaskQty;
  PpbMain? ppbMain;
  String ?createdDateAd;
  String ?createdDateBs;
  int ?status;
  String? name;
  String? expectedOutputQty;
  String? taskNo;
  String? remarks;
  bool ?isApproved;
  bool ?isCancelled;
  String? scheduleDateAd;
  int? createdBy;
  int ?department;
  int? approvedBy;

  Results(
      {this.id,
        this.taskDetails,
        this.createdByUserName,
        this.departmentName,
        this.departmentCode,
        this.approvedByUserName,
        this.statusDisplay,
        this.outputItem,
        this.remainingTaskQty,
        this.ppbMain,
        this.createdDateAd,
        this.createdDateBs,
        this.status,
        this.name,
        this.expectedOutputQty,
        this.taskNo,
        this.remarks,
        this.isApproved,
        this.isCancelled,
        this.scheduleDateAd,
        this.createdBy,
        this.department,
        this.approvedBy});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['task_details'] != null) {
      taskDetails = <TaskDetails>[];
      json['task_details'].forEach((v) {
        taskDetails!.add(new TaskDetails.fromJson(v));
      });
    }
    createdByUserName = json['created_by_user_name'];
    departmentName = json['department_name'];
    departmentCode = json['department_code'];
    approvedByUserName = json['approved_by_user_name'];
    statusDisplay = json['status_display'];
    outputItem = json['output_item'] != null?
    new OutputItem.fromJson(json['output_item'])
        : null;
    remainingTaskQty = json['remaining_task_qty'];
    ppbMain = json['ppb_main'] != null?
    new PpbMain.fromJson(json['ppb_main'])
        : null;
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    status = json['status'];
    name = json['name'];
    expectedOutputQty = json['expected_output_qty'];
    taskNo = json['task_no'];
    remarks = json['remarks'];
    isApproved = json['is_approved'];
    isCancelled = json['is_cancelled'];
    scheduleDateAd = json['schedule_date_ad'];
    createdBy = json['created_by'];
    department = json['department'];
    approvedBy = json['approved_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.taskDetails != null) {
      data['task_details'] = this.taskDetails!.map((v) => v.toJson()).toList();
    }
    data['created_by_user_name'] = this.createdByUserName;
    data['department_name'] = this.departmentName;
    data['department_code'] = this.departmentCode;
    data['approved_by_user_name'] = this.approvedByUserName;
    data['status_display'] = this.statusDisplay;
    if (this.outputItem != null) {
      data['output_item'] = this.outputItem!.toJson();
    }
    data['remaining_task_qty'] = this.remainingTaskQty;
    if (this.ppbMain != null) {
      data['ppb_main'] = this.ppbMain!.toJson();
    }
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['status'] = this.status;
    data['name'] = this.name;
    data['expected_output_qty'] = this.expectedOutputQty;
    data['task_no'] = this.taskNo;
    data['remarks'] = this.remarks;
    data['is_approved'] = this.isApproved;
    data['is_cancelled'] = this.isCancelled;
    data['schedule_date_ad'] = this.scheduleDateAd;
    data['created_by'] = this.createdBy;
    data['department'] = this.department;
    data['approved_by'] = this.approvedBy;
    return data;
  }
}

class TaskDetails {
  int? id;
  String? itemName;
  String? itemCode;
  String? itemUnitName;
  String? itemCategoryName;
  double? remainingQty;
  String? createdDateAd;
  String? createdDateBs;
  String? qty;
  bool? isCancelled;
  int ?createdBy;
  int? taskMain;
  int? item;
  int? ppbDetail;

  TaskDetails(
      {this.id,
        this.itemName,
        this.itemCode,
        this.itemUnitName,
        this.itemCategoryName,
        this.remainingQty,
        this.createdDateAd,
        this.createdDateBs,
        this.qty,
        this.isCancelled,
        this.createdBy,
        this.taskMain,
        this.item,
        this.ppbDetail});

  TaskDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemName = json['item_name'];
    itemCode = json['item_code'];
    itemUnitName = json['item_unit_name'];
    itemCategoryName = json['item_category_name'];
    remainingQty = json['remaining_qty'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    qty = json['qty'];
    isCancelled = json['is_cancelled'];
    createdBy = json['created_by'];
    taskMain = json['task_main'];
    item = json['item'];
    ppbDetail = json['ppb_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_name'] = this.itemName;
    data['item_code'] = this.itemCode;
    data['item_unit_name'] = this.itemUnitName;
    data['item_category_name'] = this.itemCategoryName;
    data['remaining_qty'] = this.remainingQty;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['qty'] = this.qty;
    data['is_cancelled'] = this.isCancelled;
    data['created_by'] = this.createdBy;
    data['task_main'] = this.taskMain;
    data['item'] = this.item;
    data['ppb_detail'] = this.ppbDetail;
    return data;
  }
}

class OutputItem {
  int? id;
  String? name;
  String ?code;
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

class PpbMain {
  int?id;
  String? name;

  PpbMain({this.id, this.name});

  PpbMain.fromJson(Map<String, dynamic> json) {
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
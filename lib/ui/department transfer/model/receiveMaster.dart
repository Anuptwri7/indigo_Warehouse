class ReceiveMaster {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  ReceiveMaster({this.count, this.next, this.previous, this.results});

  ReceiveMaster.fromJson(Map<String, dynamic> json) {
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
  FromDepartment? fromDepartment;
  FromDepartment? toDepartment;
  String? createdByUserName;
  String? receivedByUserName;
  String? approvedByUserName;
  DateTime? createdDateAd;
  DateTime? createdDateBs;
  int? deviceType;
  int? appType;
  String? transferNo;
  int? transferType;
  String? grandTotal;
  String? billNo;
  String? remarks;
  bool? isApproved;
  bool? isReceived;
  bool? isCancelled;
  bool? isPicked;
  int? createdBy;
  int? approvedBy;
  int? receivedBy;

  Results(
      {this.id,
        this.fromDepartment,
        this.toDepartment,
        this.createdByUserName,
        this.receivedByUserName,
        this.approvedByUserName,
        this.createdDateAd,
        this.createdDateBs,
        this.deviceType,
        this.appType,
        this.transferNo,
        this.transferType,
        this.grandTotal,
        this.billNo,
        this.remarks,
        this.isApproved,
        this.isReceived,
        this.isCancelled,
        this.isPicked,
        this.createdBy,
        this.approvedBy,
        this.receivedBy});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromDepartment = json['from_department'] != null
        ? new FromDepartment.fromJson(json['from_department'])
        : null;
    toDepartment = json['to_department'] != null
        ? new FromDepartment.fromJson(json['to_department'])
        : null;
    createdByUserName = json['created_by_user_name'];
    receivedByUserName = json['received_by_user_name'];
    approvedByUserName = json['approved_by_user_name'];
    createdDateAd = DateTime.parse(json["created_date_ad"]);
    createdDateBs = DateTime.parse(json["created_date_bs"]);
    deviceType = json['device_type'];
    appType = json['app_type'];
    transferNo = json['transfer_no'];
    transferType = json['transfer_type'];
    grandTotal = json['grand_total'];
    billNo = json['bill_no'];
    remarks = json['remarks'];
    isApproved = json['is_approved'];
    isReceived = json['is_received'];
    isCancelled = json['is_cancelled'];
    isPicked = json['is_picked'];
    createdBy = json['created_by'];
    approvedBy = json['approved_by'];
    receivedBy = json['received_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.fromDepartment != null) {
      data['from_department'] = this.fromDepartment!.toJson();
    }
    if (this.toDepartment != null) {
      data['to_department'] = this.toDepartment!.toJson();
    }
    data['created_by_user_name'] = this.createdByUserName;
    data['received_by_user_name'] = this.receivedByUserName;
    data['approved_by_user_name'] = this.approvedByUserName;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['transfer_no'] = this.transferNo;
    data['transfer_type'] = this.transferType;
    data['grand_total'] = this.grandTotal;
    data['bill_no'] = this.billNo;
    data['remarks'] = this.remarks;
    data['is_approved'] = this.isApproved;
    data['is_received'] = this.isReceived;
    data['is_cancelled'] = this.isCancelled;
    data['is_picked'] = this.isPicked;
    data['created_by'] = this.createdBy;
    data['approved_by'] = this.approvedBy;
    data['received_by'] = this.receivedBy;
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
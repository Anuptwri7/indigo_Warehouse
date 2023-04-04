class DropMatser {
  int? count;
  Null? next;
  Null? previous;
  List<Results>? results;

  DropMatser({this.count, this.next, this.previous, this.results});

  DropMatser.fromJson(Map<String, dynamic> json) {
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
  List<PuPackTypeCodes>? puPackTypeCodes;
  String? itemName;
  int? packingType;
  int? refDepartmentTransferDetail;

  Results(
      {this.id,
        this.puPackTypeCodes,
        this.itemName,
        this.packingType,
        this.refDepartmentTransferDetail});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['pu_pack_type_codes'] != null) {
      puPackTypeCodes = <PuPackTypeCodes>[];
      json['pu_pack_type_codes'].forEach((v) {
        puPackTypeCodes!.add(new PuPackTypeCodes.fromJson(v));
      });
    }
    itemName = json['item_name'];
    packingType = json['packing_type'];
    refDepartmentTransferDetail = json['ref_department_transfer_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.puPackTypeCodes != null) {
      data['pu_pack_type_codes'] =
          this.puPackTypeCodes!.map((v) => v.toJson()).toList();
    }
    data['item_name'] = this.itemName;
    data['packing_type'] = this.packingType;
    data['ref_department_transfer_detail'] = this.refDepartmentTransferDetail;
    return data;
  }
}

class PuPackTypeCodes {
  int? id;
  int? location;
  String? createdDateAd;
  String? createdDateBs;
  int? deviceType;
  int? appType;
  String? code;
  String? qty;
  String? weight;
  int? createdBy;
  int? purchaseOrderDetail;
  int? refPackingTypeCode;

  PuPackTypeCodes(
      {this.id,
        this.location,
        this.createdDateAd,
        this.createdDateBs,
        this.deviceType,
        this.appType,
        this.code,
        this.qty,
        this.weight,
        this.createdBy,
        this.purchaseOrderDetail,
        this.refPackingTypeCode});

  PuPackTypeCodes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    createdDateAd = json['created_date_ad'];
    createdDateBs = json['created_date_bs'];
    deviceType = json['device_type'];
    appType = json['app_type'];
    code = json['code'];
    qty = json['qty'];
    weight = json['weight'];
    createdBy = json['created_by'];
    purchaseOrderDetail = json['purchase_order_detail'];
    refPackingTypeCode = json['ref_packing_type_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    data['created_date_ad'] = this.createdDateAd;
    data['created_date_bs'] = this.createdDateBs;
    data['device_type'] = this.deviceType;
    data['app_type'] = this.appType;
    data['code'] = this.code;
    data['qty'] = this.qty;
    data['weight'] = this.weight;
    data['created_by'] = this.createdBy;
    data['purchase_order_detail'] = this.purchaseOrderDetail;
    data['ref_packing_type_code'] = this.refPackingTypeCode;
    return data;
  }
}
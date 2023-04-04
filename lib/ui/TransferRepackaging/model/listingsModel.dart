class Listings {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  Listings({this.count, this.next, this.previous, this.results});

  Listings.fromJson(Map<String, dynamic> json) {
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
  int? transferType;
  String? transferNo;
  bool? isReceived;

  Results({this.id, this.transferType, this.transferNo,this.isReceived});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transferType = json['transfer_type'];
    transferNo = json['transfer_no'];
    isReceived = json['is_received'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transfer_type'] = this.transferType;
    data['transfer_no'] = this.transferNo;
    data['is_received'] = this.isReceived;
    return data;
  }
}
class PackingType {
  int? count;
  String? next;
  Null? previous;
  List<ResultsPackingType>? results;

  PackingType({this.count, this.next, this.previous, this.results});

  PackingType.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <ResultsPackingType>[];
      json['results'].forEach((v) {
        results!.add(new ResultsPackingType.fromJson(v));
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

class ResultsPackingType {
  int? id;
  String? name;

  ResultsPackingType({this.id, this.name});

  ResultsPackingType.fromJson(Map<String, dynamic> json) {
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
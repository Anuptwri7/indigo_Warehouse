import 'dart:convert';

PackTypeListUnSerializable packTypeListUnSerializableFromJson(String str) => PackTypeListUnSerializable.fromJson(json.decode(str));

String packTypeListUnSerializableToJson(PackTypeListUnSerializable data) => json.encode(data.toJson());

class PackTypeListUnSerializable {
  PackTypeListUnSerializable({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<Result> results;

  factory PackTypeListUnSerializable.fromJson(Map<String, dynamic> json) => PackTypeListUnSerializable(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    required this.id,
    required this.code,
    required this.qty,
    required this.locationCode,
    required this.remainingQty,
    required this.soldQty,
    required this.returnQty,
    required this.repacketQty,
  });

  int id;
  String code;
  double qty;
  String locationCode;
  double remainingQty;
  double soldQty;
  double returnQty;
  double repacketQty;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    code: json["code"],
    qty: json["qty"],
    locationCode: json["location_code"],
    remainingQty: json["remaining_qty"],
    soldQty: json["sold_qty"],
    returnQty: json["return_qty"],
    repacketQty: json["repacket_qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "qty": qty,
    "location_code": locationCode,
    "remaining_qty": remainingQty,
    "sold_qty": soldQty,
    "return_qty": returnQty,
    "repacket_qty": repacketQty,
  };
}

// To parse this JSON data, do
//
//     final availableCodes = availableCodesFromJson(jsonString);

import 'dart:convert';

AvailableCodes availableCodesFromJson(String str) => AvailableCodes.fromJson(json.decode(str));

String availableCodesToJson(AvailableCodes data) => json.encode(data.toJson());

class AvailableCodes {
  AvailableCodes({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  String? next;
  dynamic? previous;
  List<ResultCodes>? results;

  factory AvailableCodes.fromJson(Map<String, dynamic> json) => AvailableCodes(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: List<ResultCodes>.from(json["results"].map((x) => ResultCodes.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class ResultCodes {
  ResultCodes({
    this.id,
    this.code,
    this.packTypeCode,
  });

  int? id;
  String? code;
  int? packTypeCode;

  factory ResultCodes.fromJson(Map<String, dynamic> json) => ResultCodes(
    id: json["id"],
    code: json["code"],
    packTypeCode: json["pack_type_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "pack_type_code": packTypeCode,
  };
}

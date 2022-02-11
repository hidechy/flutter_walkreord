// To parse this JSON data, do
//
//     final walk = walkFromJson(jsonString);

import 'dart:convert';

Walk walkFromJson(String str) => Walk.fromJson(json.decode(str));

String walkToJson(Walk data) => json.encode(data.toJson());

class Walk {
  Walk({
    required this.data,
    required this.hasNext,
  });

  List<Datum> data;
  bool hasNext;

  factory Walk.fromJson(Map<String, dynamic> json) => Walk(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasNext: json["hasNext"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "hasNext": hasNext,
      };
}

class Datum {
  Datum({
    required this.date,
    required this.step,
    required this.distance,
    required this.timeplace,
    required this.temple,
    required this.mercari,
    required this.train,
  });

  DateTime date;
  int step;
  int distance;
  String timeplace;
  String temple;
  String mercari;
  String train;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: DateTime.parse(json["date"]),
        step: json["step"],
        distance: json["distance"],
        timeplace: json["timeplace"],
        temple: json["temple"],
        mercari: json["mercari"],
        train: json["train"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "step": step,
        "distance": distance,
        "timeplace": timeplace,
        "temple": temple,
        "mercari": mercari,
        "train": train,
      };
}

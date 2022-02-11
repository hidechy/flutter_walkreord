// To parse this JSON data, do
//
//     final walk = walkFromJson(jsonString);

import 'dart:convert';

List<Walk> walkFromJson(String str) =>
    List<Walk>.from(json.decode(str).map((x) => Walk.fromJson(x)));

String walkToJson(List<Walk> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Walk {
  Walk({
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

  factory Walk.fromJson(Map<String, dynamic> json) => Walk(
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

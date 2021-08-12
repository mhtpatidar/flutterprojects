import 'package:flutter/cupertino.dart';

class History{

  int Id;
  String Name, mobile, date, weather;

  History({required this.Id, required this.Name, required this.mobile, required this.date, required this.weather});

  //to be used when inserting a row in the table
  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["place_name"] = Name;
    map["emp_mobile"] = mobile;
    map["emp_date"] = date;
    map["emp_weather"] = weather;
    return map;
  }

  //to be used when updating a row in the table
  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["place_name"] = Name;
    map["emp_mobile"] = mobile;
    map["emp_date"] = date;
    map["emp_weather"] = weather;
    return map;
  }

  //to be used when converting the row into object
  factory History.fromMap(Map<String, dynamic> data) => new History(
      Id: data['id'],
      Name: data['place_name'],
      mobile: data['emp_mobile'],
      date: data['emp_date'],
      weather: data['emp_weather']
  );
}
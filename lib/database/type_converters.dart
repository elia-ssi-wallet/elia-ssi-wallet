import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:elia_ssi_wallet/models/activity.dart';

// * DateTime Converter
class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> fromSql(String fromDb) {
    List<String> stringList = [];
    List<dynamic> list = json.decode(fromDb);

    stringList = list.cast<String>();

    return stringList;
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}

//* Activity Converter
class ActivityListConverter extends TypeConverter<List<Activity>, String> {
  @override
  List<Activity> fromSql(String fromDb) {
    List<Activity> activityList = [];
    List<dynamic> list = json.decode(fromDb);

    activityList = List<Activity>.from(list.map((model) => Activity.fromJson(model)));
    return activityList;
  }

  @override
  String toSql(List<Activity> value) {
    return jsonEncode(value);
  }
}

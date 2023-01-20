import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity {
  String name;
  DateTime date;
  String icon;

  Activity({
    required this.name,
    required this.date,
    this.icon = '',
  });

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  @override
  String toString() => 'Activity(name: $name, date: $date, icon: $icon)';
}

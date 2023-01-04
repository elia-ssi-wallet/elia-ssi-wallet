
//* DateTime Converter
// class DateTimeConverter extends TypeConverter<DateTime, String> {
//   @override
//   DateTime? mapToDart(String? fromDb) {
//     if (fromDb == null) return null;

//     return DateTime.parse(fromDb);
//   }

//   @override
//   String? mapToSql(DateTime? value) {
//     if (value == null) return null;

//     return value.toIso8601String();
//   }
// }

// //* StringList Converter
// class StringListConverter extends TypeConverter<List<String>, String> {
//   @override
//   List<String>? mapToDart(String? fromDb) {
//     if (fromDb == null) {
//       return null;
//     } else {
//       List<String> stringList = [];
//       List<dynamic> list = json.decode(fromDb);

//       stringList = list.cast<String>();

//       return stringList;
//     }
//   }

//   @override
//   String? mapToSql(List<String>? value) {
//     if (value == null) {
//       return null;
//     } else {
//       return json.encode(value);
//     }
//   }
// }

// //* IntegerList Converter
// class IntegerListConverter extends TypeConverter<List<int>, String> {
//   @override
//   List<int>? mapToDart(String? fromDb) {
//     if (fromDb == null) {
//       return null;
//     } else {
//       List<int> stringList = [];
//       List<dynamic> list = json.decode(fromDb);

//       stringList = list.cast<int>();

//       return stringList;
//     }
//   }

//   @override
//   String? mapToSql(List<int>? value) {
//     if (value == null) {
//       return null;
//     } else {
//       return json.encode(value);
//     }
//   }
// }

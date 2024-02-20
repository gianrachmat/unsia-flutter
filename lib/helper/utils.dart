import 'package:intl/intl.dart';

String getDate() {
  var now = DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

String toEDMY(String date) {
  var now = DateFormat('dd-MM-yyyy').parse(date);
  var formatter = DateFormat('EEEE, dd-MM-yyyy');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

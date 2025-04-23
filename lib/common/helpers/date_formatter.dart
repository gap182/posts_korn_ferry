import 'package:intl/intl.dart';

String postDateFormatted(DateTime date) {
  return DateFormat.yMMMMd().format(date);
}

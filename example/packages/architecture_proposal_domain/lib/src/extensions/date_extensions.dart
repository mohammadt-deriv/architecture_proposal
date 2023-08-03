import 'package:intl/intl.dart';

extension DateTimeExtension on int {
  String get getFormattedDateTime => DateFormat('yyyy-MM-dd HH:mm:ss')
      .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));

  String get getFormattedTime => DateFormat('HH:mm:ss')
      .format(DateTime.fromMillisecondsSinceEpoch(this * 1000));
}

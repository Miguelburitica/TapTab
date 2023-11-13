import 'package:intl/intl.dart';

String getLastTimeUpdated(DateTime updatedAt) {
  final now = DateTime.now();
  final differenceInMinutes = now.difference(updatedAt).inMinutes;
  final differenceInHours = now.difference(updatedAt).inHours;
  if (differenceInHours > 0) {
    return 'hace $differenceInHours horas';
  }

  return differenceInMinutes > 0 ? 'hace $differenceInMinutes minutos' : 'hace unos segundos';
}

String formatCurrency(double value) {
  final formatter = NumberFormat.currency(locale: 'es_CO', decimalDigits: 0, symbol: '\$');
  return formatter.format(value);
}

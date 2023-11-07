String getLastTimeUpdated(DateTime updatedAt) {
  final now = DateTime.now();
  final differenceInMinutes = now.difference(updatedAt).inMinutes;
  final differenceInHours = now.difference(updatedAt).inHours;
  if (differenceInHours > 0) {
    return 'hace $differenceInHours horas';
  }

  return differenceInMinutes > 0 ? 'hace $differenceInMinutes minutos' : 'hace unos segundos';
}
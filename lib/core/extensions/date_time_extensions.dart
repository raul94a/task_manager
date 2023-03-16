extension DateTimeExtension on DateTime{

  String toSpanishDate() {
    String date = '$day/$month/$year';
    return date;
  }

  String toSpanishDateTime() => '$day/$month/$year $hour:$minute:$second';
}
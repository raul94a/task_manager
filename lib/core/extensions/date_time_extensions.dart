extension DateTimeExtension on DateTime{

  String toSpanishDate() {
    String day = this.day < 10 ? '0${this.day}' : '${this.day}';   
    String month = this.month < 10 ? '0${this.month}' : '${this.month}'; 
    String date = '$day/$month/$year';
    return date;
  }

  String toSpanishDateTime() => '$day/$month/$year $hour:$minute:$second';
}
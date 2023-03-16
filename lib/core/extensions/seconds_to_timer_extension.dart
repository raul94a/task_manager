extension SecondsToClock on int {
  String toTimer() {
    if (this < 60) {
      return '00:00:${this < 10 ? "0$this" : this}';
    }
    final minutes = this ~/ 60;
    if (minutes < 60) {
      final remainingSeconds = this % 60;
      final correctSecondsString =
          remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
      final correctMinutes = minutes < 10 ? "0$minutes" : minutes;
      return '00:$correctMinutes:$correctSecondsString';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = (this - hours * 3600) ~/ 60;
    final remainingSeconds = this - (hours * 3600 + remainingMinutes * 60);

    final correctMinutesString =
        remainingMinutes < 10 ? '0$remainingMinutes' : remainingMinutes;
    final correctSecondsString =
        remainingSeconds < 10 ? '0$remainingSeconds' : remainingSeconds;
    final correctHourString = hours < 10 ? '0$hours' : '$hours';

    return '$correctHourString:$correctMinutesString:$correctSecondsString';
  }

  String toTime() {
    if (this < 60) {
      return '$this segundos.';
    }
    final minutes = this ~/ 60;
    if (minutes < 60) {
      final remainingSeconds = this % 60;
      final correctSecondsString =
          remainingSeconds < 10 ? '0$remainingSeconds' : '$remainingSeconds';
      final correctMinutes = minutes < 10 ? "0$minutes" : minutes;
      return '$minutes minutos y $remainingSeconds segundos.';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = (this - hours * 3600) ~/ 60;
    final remainingSeconds = this - (hours * 3600 + remainingMinutes * 60);

    final correctMinutesString =
        remainingMinutes < 10 ? '0$remainingMinutes' : remainingMinutes;
    final correctSecondsString =
        remainingSeconds < 10 ? '0$remainingSeconds' : remainingSeconds;
    final correctHourString = hours < 10 ? '0$hours' : '$hours';

    return '$hours horas $remainingMinutes y $remainingSeconds segundos.';
  }
}

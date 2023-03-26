// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/task_model.dart';

final timerStateNotifierProvider =
    StateNotifierProvider((ref) => ref.read(timerState.notifier));

final timerState = StateProvider((ref) {
  final timerProvider = TimerStateProvider();
  // ref.onDispose(() {
  //   timerProvider.dispose();
  // });
  return timerProvider;
});

class TimerStateProvider {
  StreamController<int> controller = StreamController<int>.broadcast();
  Task? task;

  bool timerRunning;
  StreamSubscription<int>? subscription;

  TimerStateProvider({this.task,  this.timerRunning = false, this.subscription});

  TimerStateProvider.withController({this.task, this.timerRunning  = false, this.subscription, required this.controller});

  TimerStateProvider copyWith(
      {Task? task, StreamController<int>? controller, bool? timerRunning, StreamSubscription<int>? subscription}) {
    return TimerStateProvider(
      task: task ?? this.task,
     
      subscription: subscription ?? this.subscription,
      timerRunning: timerRunning ?? this.timerRunning,
    );
  }
  TimerStateProvider copyWithController({Task? task, StreamController<int>? controller, bool? timerRunning, StreamSubscription<int>? subscription}){
    return TimerStateProvider.withController(
      task: task ?? this.task,
      controller: controller ?? this.controller,
      subscription: subscription ?? this.subscription,
      timerRunning: timerRunning ?? this.timerRunning,
    );
  }

  TimerStateProvider withTask(Task? task) {
    return TimerStateProvider(task: task);
  }

  TimerStateProvider clearTask(){
    return TimerStateProvider(task: null, timerRunning: timerRunning, subscription: subscription);
  }

  // void startTimer() {
  //   // subscription?.cancel();
    

  //   Stream<int> timerStream = tick(fromSeconds: task!.seconds);
  //   subscription = timerStream.listen(controller.add);
  //   print('subscribe');
  // }

  Stream<int> tick({required int fromSeconds}) {
    return Stream.periodic(
        const Duration(seconds: 1), (second) => fromSeconds + second);
  }

  resume() {
    subscription?.resume();
  }

  pause() {
    subscription?.pause();
  }

  disposeSubscription() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  String toString() => 'TimerStateProvider(task: $task})';
}

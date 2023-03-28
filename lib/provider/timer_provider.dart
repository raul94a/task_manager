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
  Task? task;

  bool timerRunning;


  TimerStateProvider({this.task,  this.timerRunning = false});

  TimerStateProvider.withController({this.task, this.timerRunning  = false, });

  TimerStateProvider copyWith(
      {Task? task, bool? timerRunning,}) {
    return TimerStateProvider(
      task: task ?? this.task,
     
    
      timerRunning: timerRunning ?? this.timerRunning,
    );
  }
 

  TimerStateProvider withTask(Task? task) {
    return TimerStateProvider(task: task);
  }

  TimerStateProvider clearTask(){
    return TimerStateProvider(task: null, timerRunning: timerRunning, );
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


  @override
  String toString() => 'TimerStateProvider(task: $task})';
}

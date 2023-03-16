// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/task_model.dart';

final updateTaskTimeNotifierProvider =
    StateNotifierProvider((ref) => ref.read(updateTaskTimeState.notifier));

final updateTaskTimeState = StateProvider((ref) {
  final timerProvider = UpdateTaskTimeProvider();
  
  return timerProvider;
});

class UpdateTaskTimeProvider {
  Task? task;

  UpdateTaskTimeProvider({this.task,});

  UpdateTaskTimeProvider copyWith(
      {Task? task, StreamController<int>? controller, bool? timerRunning, StreamSubscription<int>? subscription}) {
    return UpdateTaskTimeProvider(
      task: task ?? this.task,
     
   
    );
  }
  
  @override
  String toString() => 'TimerStateProvider(task: $task})';
}

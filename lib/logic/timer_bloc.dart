import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/provider/timer_provider.dart';

class TimerBloc {
  const TimerBloc({required this.ref});

  final WidgetRef ref;

  void prepareTimer({required Task task}) {
    final notifier = ref.read(timerState.notifier);
    final timeInMillis = task.timeInMillis;
    final checkMillis = timeInMillis == null ? 0 : task.timeInMillis;
    notifier.update((state) => state.copyWith(
          task: task,
        ));
  }

  // void startRun({required Stream<int> stream}) {
  //   final state = ref.read(timerState);
  //   final controller = state.controller;
  //   print('StreamController paused: ${controller.isPaused}');

  //   final subscription = stream.listen((data) {
  //     //controller.sink.add(data);
  //   });
  //  // subscription.resume();

  //   print('Subscribing stream');
  //   print('StreamController paused: ${controller.isPaused}');
  //   print('StreamController closed: ${controller.isClosed}');
  //   print('Subscription is paused ?  ${subscription.isPaused}');
  //   final notifier = ref.read(timerState.notifier);
  //   notifier.update((state) => state.copyWith(
  //       timerRunning: true,
  //       subscription: subscription,
  //       controller: controller));
  // }
  void startRun() {
    ref
        .read(timerState.notifier)
        .update((state) => state.copyWith(timerRunning: true));
  }

  void pauseRun() {
    ref.read(timerState.notifier).update(
          (state) => state.copyWith(timerRunning: false),
        );
  }

  void resumeRun() {
    ref.read(timerState.notifier).update((state) => state.copyWith(
        timerRunning: true, ));
  }


  void clearTimer(){
    ref.read(timerState.notifier).update((state) => TimerStateProvider(task: null));
  }
}

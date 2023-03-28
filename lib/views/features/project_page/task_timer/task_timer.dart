import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/core/extensions/seconds_to_timer_extension.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/logic/timer_bloc.dart';
import 'package:task_manager/provider/select_tasks_provider.dart';
import 'package:task_manager/provider/task_project_provider.dart';
import 'package:task_manager/provider/timer_provider.dart';
import 'package:task_manager/provider/timer_stream.provider.dart';
import 'package:task_manager/provider/update_task_time_provider.dart';

class TaskTimer extends ConsumerStatefulWidget {
  const TaskTimer({
    super.key,
  });

  @override
  ConsumerState<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends ConsumerState<TaskTimer> {
  late TimerStateProvider mTimerState = ref.read(timerState);
  ValueNotifier<bool> startStreaming = ValueNotifier(false);
  bool isCurrentTaskRunning = false;

  late int secondsToStartStreaming;
  late StreamController<int> controller;
  StreamSubscription<int>? subscription;
  changeStartStreamingStatus() {
    startStreaming.value = !startStreaming.value;
  }

  @override
  void initState() {
    controller = ref.read(timerStreamProvider).controller;
    // if (!mTimerState.timerRunning) {
    //   mTimerState.task = task;
    // } else {
    //   startStreaming.value = true;
    // }
    // if ((mTimerState.task != null && task != null) &&
    //     mTimerState.task?.id == task!.id) {
    //   isCurrentTaskRunning = true;
    // }
    super.initState();
  }

  @override
  void dispose() {
    // startStreaming.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    mTimerState = ref.watch(timerState);
    Task? task = mTimerState.task;
    print('tasks seconds: ${task?.seconds}');
    if (task == null) {
      return const Center();
    }

    final updatedTask = ref.read(updateTaskTimeState).task;
    if (updatedTask != null && updatedTask.id == task.id) {
      task = task.copyWith(timeInMillis: updatedTask.timeInMillis);
    }
    secondsToStartStreaming = task.seconds;

    final tasksProvider = ref.read(tasksProjectState);
    final taskIndex = tasksProvider.tasks.indexWhere((e) => e.id == task!.id);

    print('Rebuildintg task timer');

    return Container(
        decoration: const BoxDecoration(),
        width: 400,
        height: 200,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SvgPicture.asset(
              'assets/timer.svg',
              color: Colors.white,
              width: 90,
            ),
            if (!mTimerState.timerRunning)
              AutoSizeText(
                task.seconds.toTimer(),
                minFontSize: 21,
              )
            else
              StreamBuilder<int>(
                  initialData: task.seconds,
                  stream: controller.stream,
                  builder: (context, snapshot) {
                    // print(snapshot);
                    final data = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return AutoSizeText(
                        data == null ? "00:00:00" : data.toTimer(),
                        minFontSize: 21,
                      );
                    }
                    if (data != null) {
                      Future.microtask(() {
                        final timeInMillis = data * 1000;
                        final newTask = task!.copyWith(timeInMillis: timeInMillis);
                        final updateTaskNotifier =
                            ref.read(updateTaskTimeState.notifier);
                        updateTaskNotifier.update((state) => state.copyWith(
                            task: newTask));

                        if (data % 10 == 0) {
                        print('Updating task: $newTask');
                          TaskRepository().update(newTask);
                        }
                      });
                    }

                    return AutoSizeText(
                      data == null ? "00:00:00" : data.toTimer(),
                      minFontSize: 21,
                    );
                  }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => onPressTimerButton(
                        ref: ref,
                        timerBloc: TimerBloc(ref: ref),
                        tasksProvider: tasksProvider,
                        taskIndex: taskIndex),
                    icon: Consumer(builder: (context, ref, _) {
                      final timerProvider = ref.watch(timerState);
                      return Icon(
                        timerProvider.timerRunning &&
                                (task!.id == timerProvider.task!.id)
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 50,
                      );
                    })),
                Consumer(builder: (ctx, ref, _) {
                  final timerProvider = ref.watch(timerState);
                  if (timerProvider.timerRunning &&
                      (task!.id == timerProvider.task!.id)) {
                    return IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          subscription =
                              ref.read(timerStreamProvider).subscription;
                          //when the view is disposed
                          //the subscription is null!
                          //the way to stop the close is by closing the controller
                          if (subscription == null) {
                            controller.close();
                          }

                          ref.read(timerStreamProvider).subscription?.cancel();
                          ref.read(timerStreamProvider).subscription = null;

                          final task = ref.read(updateTaskTimeState).task!;
                          try {
                            TasksProjectBloc(ref: ref).updateTask(task: task);
                          } catch (ex) {
                            print(ex);
                          }
                         
                          TimerBloc(ref: ref).pauseRun();
                          TaskRepository().update(task);
                          ref.read(timerState.notifier).state =
                              TimerStateProvider(
                                  task: null, timerRunning: false);
                          ref
                              .read(selectTaskState.notifier)
                              .update((state) => state.copyWith(taskId: null));
                        },
                        icon: const Icon(
                          Icons.stop,
                          size: 50,
                        ));
                  }
                  return const Center();
                })
              ],
            )
          ],
        ));
  }

  onPressTimerButton({
    required WidgetRef ref,
    required TimerBloc timerBloc,
    required TaskProjectStateProvider tasksProvider,
    required int taskIndex,
  }) {
    subscription = ref.read(timerStreamProvider).subscription;
    print('TAG SUBSCRIPTION: ${subscription?.isPaused}');

    if (subscription != null && !subscription!.isPaused) {
      print('On pause');
      subscription!.pause();
      timerBloc.pauseRun();

      final task = ref.read(updateTaskTimeState).task!;
      TaskRepository().update(task);
    } else if (subscription != null && subscription!.isPaused) {
      subscription!.resume();
      timerBloc.startRun();
      print('On resume!');
    } else {
      print('Start Timer');
      startTimer();
    }
  }

  Stream<int> getStream({required int from}) =>
      Stream.periodic(const Duration(seconds: 1), (sec) => from + sec);

  Stream<int> get stream => controller.stream;

  Sink<int> get sink => controller.sink;

  void startTimer() {
    final timerState = ref.read(timerStreamProvider);
    timerState.subscription = getStream(from: secondsToStartStreaming).listen(
      (sec) {
        
        controller.sink.add(sec);
      },
      onDone: () {
        subscription = null;
        print('On done');
      },
    );
    subscription = timerState.subscription;
    TimerBloc(ref: ref).startRun();
  }
}

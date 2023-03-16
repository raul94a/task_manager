import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/extensions/date_time_extensions.dart';
import 'package:task_manager/core/extensions/seconds_to_timer_extension.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/logic/timer_bloc.dart';
import 'package:task_manager/provider/task_project_provider.dart';
import 'package:task_manager/provider/timer_provider.dart';

class ProjectTaskInfo extends ConsumerStatefulWidget {
  const ProjectTaskInfo(
      {super.key, required this.task, required this.projectPageRef});

  final Task task;
  final WidgetRef projectPageRef;

  @override
  ConsumerState<ProjectTaskInfo> createState() => _ProjectTaskInfoState();
}

class _ProjectTaskInfoState extends ConsumerState<ProjectTaskInfo> {
  ValueNotifier<bool> notifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building task info for ${widget.task.name}');
    void changeShowStatus() {
      final timerProvider = ref.read(timerState);
      final timerBloc = TimerBloc(ref: ref);

      if (!timerProvider.timerRunning && !notifier.value) {
        print('Changing task for timer');
        timerBloc.prepareTimer(task: widget.task);
      }
      notifier.value = !notifier.value;
    }

    return GestureDetector(
      onTap: changeShowStatus,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Row(
                key: widget.key,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: AutoSizeText(widget.task.name)),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          constraints: const BoxConstraints(maxWidth: 150),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(100, 60)),
                              color: Colors.pinkAccent),
                          child: AutoSizeText(
                            widget.task.category,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                      child: AutoSizeText(
                    'Raul',
                    textAlign: TextAlign.start,
                  )),
                  Expanded(
                      child:
                          AutoSizeText(widget.task.createdAt.toSpanishDate()))
                ],
              ),
            ),
            ValueListenableBuilder(
                valueListenable: notifier,
                builder: (ctx, show, _) => TaskExtendedInfo(
                      show: show,
                      task: widget.task,
                      projectPageRef: widget.projectPageRef,
                    ))
          ],
        ),
      ),
    );
  }
}

class TaskExtendedInfo extends ConsumerWidget {
  const TaskExtendedInfo(
      {super.key,
      required this.show,
      required this.task,
      required this.projectPageRef});
  final bool show;
  final Task task;
  final WidgetRef projectPageRef;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeInMillis = task.timeInMillis;
    final isTaskStarted = task.timeInMillis != null;
    return Visibility(
      maintainState: false,
      visible: show,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0), color: Colors.indigo),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SizedBox(
                height: 190,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ///Escription
                    Wrap(
                      direction: Axis.vertical,
                      children: [
                        Text('Descripción'),
                        Text(task.description + 'fdsahklfhadklf'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer(builder: (context, ref, _) {
                          final task = ref
                              .watch(timerState.select((value) => value.task));

                          int dedicatedTime = 0;
                          if (task != null &&
                              this.task.id == task.id &&
                              ref.read(timerState).timerRunning) {
                            print(
                                'The task is the same as selected: ${this.task.id}/${task.id}');
                            dedicatedTime = task.seconds;
                          } else {
                            print('The task is not the same as selected one');
                            print('${this.task.name}/${task?.name}');
                            dedicatedTime = this.task.seconds;
                          }

                          //print('rebuilding tiempo dedicado with task $task');

                          return Text(
                              'Tiempo dedicado: ${isTaskStarted ? dedicatedTime.toTime() : '-'}');
                        }),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {}, child: Text('Abandonar')),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {}, child: Text('Finalizar')),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _TaskTimer(
              task: task,
            )
          ],
        ),
      ),
    );
  }
}

class _TaskTimer extends ConsumerStatefulWidget {
  const _TaskTimer({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  ConsumerState<_TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends ConsumerState<_TaskTimer> {
  late TimerStateProvider mTimerState = ref.read(timerState);
  ValueNotifier<bool> startStreaming = ValueNotifier(false);
  bool isCurrentTaskRunning = false;

  changeStartStreamingStatus() {
    startStreaming.value = !startStreaming.value;
  }

  @override
  void initState() {
    if (!mTimerState.timerRunning) {
      mTimerState.task = widget.task;
    } else {
      startStreaming.value = true;
    }
    if (mTimerState.task != null && mTimerState.task?.id == widget.task.id) {
      isCurrentTaskRunning = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    startStreaming.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final tasksProvider = ref.read(tasksProjectState);
    final taskIndex =
        tasksProvider.tasks.indexWhere((e) => e.id == widget.task.id);

    print('Rebuildintg task timer');
    final taskWath = ref.read(timerState.select((value) => value.task));
    print(taskWath);
    final timerRunningWatch =
        ref.read(timerState.select((value) => value.timerRunning));
    if (taskWath!.id != widget.task.id && timerRunningWatch) {
      return Center(
        child: Text(
            'El reloj está activo para la tarea ${mTimerState.task?.name}'),
      );
    }
    return Container(
        decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.black))),
        width: 400,
        height: 200,
        child: Visibility(
          replacement: Center(
            child: Text(
                'El reloj está activo para la tarea ${mTimerState.task?.name}'),
          ),
          visible: isCurrentTaskRunning,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Icon(
                Icons.timer,
                color: Colors.black,
                size: 90,
              ),
              ValueListenableBuilder(
                  valueListenable: startStreaming,
                  builder: (context, show, _) {
                    final subscription = ref.watch(
                        timerState.select((value) => value.subscription));

                    if (!show && (widget.task.id != mTimerState.task!.id)) {
                      return AutoSizeText(
                        mTimerState.task == null
                            ? widget.task.seconds.toTimer()
                            : mTimerState.task!.seconds.toTimer(),
                        minFontSize: 21,
                      );
                    }

                    print('Rebuilding! Paused: ${subscription?.isPaused}');

                    print('SUBSCRIPTION: $subscription');
                    //final controller =ref.watch(timerState.select((value) => value.controller));
                    subscription?.onData((data) {
                      print('subscription $data');
                      mTimerState.controller.sink.add(data);
                    });

                    return StreamBuilder<int>(
                        initialData: mTimerState.task == null
                            ? widget.task.seconds
                            : mTimerState.task!.seconds,
                        stream: mTimerState.controller
                            .stream
                            .asBroadcastStream(),
                        builder: (context, snapshot) {
                          print(snapshot);
                          final data = snapshot.data;
                          if (data != null) {
                            Future.microtask(() {
                              TimerBloc(ref: ref).addSeconds(seconds: data);
                              final newTask = ref.read(timerState).task!;
                              //print('Updating task: ${newTask.timeInMillis}');
                              if (data % 10 == 0) {
                                TaskRepository().update(newTask);
                              }
                            });
                          }

                          return AutoSizeText(
                            data == null ? "00:00:00" : data.toTimer(),
                            minFontSize: 21,
                          );
                        });
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
                                  (widget.task.id == timerProvider.task!.id)
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 50,
                        );
                      })),
                  Consumer(builder: (ctx, ref, _) {
                    final timerProvider = ref.watch(timerState);
                    if (timerProvider.timerRunning &&
                        (widget.task.id == timerProvider.task!.id)) {
                      return IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            TimerBloc(ref: ref).destroyTimer();
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
          ),
        ));
  }

  onPressTimerButton({
    required WidgetRef ref,
    required TimerBloc timerBloc,
    required TaskProjectStateProvider tasksProvider,
    required int taskIndex,
  }) {
    final timerProvider = ref.read(timerState);
    // bool isSelected = timerProvider.task!.id == widget.task.id;
    print('onPressTimerButton');
    print('Selected task ${timerProvider.task?.name}');
    print('Widget task ${widget.task.name}');
    if (timerProvider.timerRunning &&
        (timerProvider.task!.id != widget.task.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ya hay una tarea siendo cronometrada')));
      return;
    }
    if (timerProvider.task!.id != widget.task.id) {
      TimerBloc(ref: ref).prepareTimer(task: widget.task);
      final stream = Stream.periodic(
          const Duration(seconds: 1), (sec) => widget.task.seconds + sec);
      timerBloc.startRun(stream: stream);

      changeStartStreamingStatus();
      return;
    }

    if (timerProvider.subscription != null &&
        !timerProvider.subscription!.isPaused) {
      print('In puase');
      timerBloc.pauseRun();
      // pauseTimer();
      return;
    }
    if (timerProvider.subscription != null &&
        timerProvider.subscription!.isPaused) {
      print('In resume');

      timerBloc.resumeRun();

      return;
    }
    print('In generating new stream');

    final stream = Stream.periodic(
        const Duration(seconds: 1), (sec) => widget.task.seconds + sec);
    timerBloc.startRun(stream: stream);

    changeStartStreamingStatus();
  }

  // void startTimer(int from) {
  //   print('Starting from $from');
  //   final stream =
  //       Stream.periodic(const Duration(seconds: 1), (sec) => from + sec);
  //   print('Creating stream $stream');
  //   subcription = stream.listen(controller.sink.add);
  //   //controller.sink.addStream(stream);
  //   print('Stream has been merge into the controller');
  // }

  // void pauseTimer() {
  //   subcription?.pause();
  // }

  // void resumeTimer() {
  //   subcription?.resume();
  // }

  // void disposeTimer() {
  //   subcription?.cancel();
  // }
}

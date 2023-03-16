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
      }else{
        print('CANNOT CHANGE TASK');
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
           
          ],
        ),
      ),
    );
  }
}

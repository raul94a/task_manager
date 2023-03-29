import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/task_status_enum.dart';
import 'package:task_manager/core/extensions/context_extension.dart';
import 'package:task_manager/core/extensions/date_time_extensions.dart';
import 'package:task_manager/core/extensions/seconds_to_timer_extension.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/logic/select_task_bloc.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/logic/timer_bloc.dart';
import 'package:task_manager/provider/select_tasks_provider.dart';
import 'package:task_manager/provider/theme_provider.dart';
import 'package:task_manager/provider/timer_provider.dart';
import 'package:task_manager/provider/timer_stream.provider.dart';
import 'package:task_manager/provider/update_task_time_provider.dart';
import 'package:task_manager/views/styles/app_colors.dart';
import 'package:task_manager/views/styles/form_decoration.dart';

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
  bool editMode = false;
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();

  final nameFocus = FocusNode();
  final categoryFocus = FocusNode();
  final descriptionFocus = FocusNode();

  void enableEdit() => setState(
      () => {editMode = true, notifier.value = true, nameFocus.requestFocus()});
  void disableEdit() {
    setState(() => editMode = false);
    TasksProjectBloc(ref: ref).updateTaskDB(
        task: widget.task.copyWith(
            name: nameController.text,
            description: descriptionController.text,
            category: categoryController.text));
  }

  @override
  void initState() {
    nameController.text = widget.task.name;
    categoryController.text = widget.task.category;
    descriptionController.text = widget.task.description;
    super.initState();
  }

  @override
  void dispose() {
    notifier.dispose();
    nameController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    nameFocus.dispose();
    categoryFocus.dispose();
    descriptionFocus.dispose();
    super.dispose();
  }

  void onSelectTask(String? taskId) {
    if (editMode) {
      return;
    }
    final timerStreamState = ref.read(timerStreamProvider);
    final timerProvider = ref.watch(timerState);
    final timerBloc = TimerBloc(ref: ref);
    final selectTaskBloc = SelectTaskBloc(ref: ref);

    if (timerStreamState.subscription != null &&
        timerStreamState.subscription!.isPaused) {
      context.showSnackBar(
          'Hay una tarea pausada. Debes detenerla antes de cambiar de tarea');

      return;
    }
    if (!timerProvider.timerRunning) {
      print('Changing task for timer');
      final selectedTaskId = ref.read(selectTaskState).taskId;

      if (selectedTaskId != null && selectedTaskId == widget.task.id) {
        selectTaskBloc.clearSelectedTask();
        timerBloc.clearTimer();
        return;
      }
      timerBloc.prepareTimer(task: widget.task);
      selectTaskBloc.setTask(widget.task);
      return;
    }
    context.showSnackBar(
        'Imposible seleccionar tarea. Ya hay una tarea siendo cronometrada.');
  }

  void changeShowStatus() {
    if (editMode) {
      return;
    }
    notifier.value = !notifier.value;
  }

  bool maybeHideEditButton(WidgetRef ref) {
    final timerProvider = ref.watch(timerState);
    final selectedTask =
        ref.watch(selectTaskState.select((value) => value.taskId));
    final timerStreamState = ref.read(timerStreamProvider);
    final isTaskCountingTime = timerProvider.timerRunning &&
        selectedTask != null &&
        selectedTask == widget.task.id;

    final isThisTaskSubscribed = selectedTask != null &&
        selectedTask == widget.task.id &&
        !timerProvider.timerRunning &&
        timerStreamState.subscription != null;

    return isThisTaskSubscribed || isTaskCountingTime;
  }

  @override
  Widget build(BuildContext context) {
    print('Building task info for ${widget.task.name}');

    final selectTaskStateProvider = ref.watch(selectTaskState);
    final darkMode = ref.read(themeState).darkMode;
    return GestureDetector(
      onTap: changeShowStatus,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3.0),
        decoration: BoxDecoration(
          border: darkMode ? null : Border.all(color: lateralBarBg),
          borderRadius: BorderRadius.circular(5.0),
          color: !darkMode
              ? Colors.white10
              : const Color.fromARGB(246, 44, 44, 44),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  key: widget.key,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: (widget.task.status ==
                                  TaskStatus.Pending.status &&
                              !editMode),
                          child: Radio(
                              toggleable: true,
                              fillColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (!ref.read(themeState).darkMode) {
                                  return lateralBarBg;
                                }
                                return Colors.white;
                              }),
                              value: widget.task.id,
                              groupValue: selectTaskStateProvider.taskId,
                              onChanged: onSelectTask),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        if (editMode)
                          Expanded(
                            child: TextField(
                              focusNode: nameFocus,
                              controller: nameController,
                            ),
                          )
                        else
                          AutoSizeText(widget.task.name),
                      ],
                    )),
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            constraints: const BoxConstraints(
                                maxWidth: 150, minWidth: 80),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.elliptical(80, 60)),
                                color: editMode
                                    ? Colors.transparent
                                    : Colors.pinkAccent),
                            child: Visibility(
                              visible: !editMode,
                              replacement: TextField(
                                focusNode: categoryFocus,
                                controller: categoryController,
                              ),
                              child: AutoSizeText(
                                widget.task.category,
                                textAlign: TextAlign.start,
                              ),
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
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(widget.task.createdAt.toSpanishDate()),
                        // const SizedBox(),

                        Consumer(builder: (context, ref, _) {
                          if (maybeHideEditButton(ref)) {
                            return const Center();
                          }

                          final lightMode = !ref.read(themeState).darkMode;

                          return Visibility(
                            visible:
                                widget.task.status == TaskStatus.Pending.status,
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: editMode ? disableEdit : enableEdit,
                                icon: Icon(
                                  editMode ? Icons.check : Icons.mode,
                                  size: 30,
                                  color: lightMode ? lateralBarBg : null,
                                )),
                          );
                        })
                      ],
                    ))
                  ],
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: notifier,
                  builder: (ctx, show, _) => TaskExtendedInfo(
                        show: show,
                        task: widget.task,
                        descriptionController: descriptionController,
                        editMode: editMode,
                        projectPageRef: widget.projectPageRef,
                      ))
            ],
          ),
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
      required this.projectPageRef,
      required this.descriptionController,
      required this.editMode});
  final bool show;
  final bool editMode;
  final TextEditingController descriptionController;
  final Task task;
  final WidgetRef projectPageRef;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTaskStarted = task.timeInMillis != null;
    final lightMode = !ref.read(themeState).darkMode;
    return Visibility(
      maintainState: false,
      visible: show,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ///EDscription
                    if (!editMode)
                      Wrap(
                        direction: Axis.vertical,
                        children: [Text('Descripción'), Text(task.description)],
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Descripción'),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextField(
                             
                              maxLines: 15,
                    
                              controller: descriptionController,
                            ),
                          ],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer(builder: (context, ref, _) {
                          int dedicatedTime = 0;

                          dedicatedTime = task.seconds;

                          final updateTask =
                              ref.watch(updateTaskTimeState).task;
                          if (updateTask != null && updateTask.id == task.id) {
                            dedicatedTime = updateTask.seconds;
                          }
                          return Text(
                              'Tiempo dedicado: ${isTaskStarted ? dedicatedTime.toTime() : '-'}');
                        }),
                        Visibility(
                          visible: !editMode,
                          child: Row(
                            children: [
                              _AbandonButton(
                                  task: task,
                                  onPressed: () {
                                    final newStatus = task.status ==
                                            TaskStatus.Abandoned.status
                                        ? TaskStatus.Pending.status
                                        : TaskStatus.Abandoned.status;
                                    TasksProjectBloc(ref: ref).updateTaskDB(
                                        task: task.copyWith(status: newStatus));

                                    checkIfSelected(ref);
                                  }),
                              const SizedBox(
                                width: 10,
                              ),
                              _FinishButton(
                                  lightMode: lightMode,
                                  task: task,
                                  onPressed: () {
                                    final newStatus = task.status ==
                                            TaskStatus.Completed.status
                                        ? TaskStatus.Pending.status
                                        : TaskStatus.Completed.status;

                                    TasksProjectBloc(ref: ref).updateTaskDB(
                                        task: task.copyWith(status: newStatus));
                                    //Check selection
                                    checkIfSelected(ref);
                                  }),
                              const SizedBox(
                                width: 5,
                              )
                            ],
                          ),
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

  void checkIfSelected(WidgetRef ref) {
    //Check selection
    final timerProv = ref.read(timerState);
    if (timerProv.task != null && timerProv.task?.id == task.id) {
      ref
          .read(timerState.notifier)
          .update((state) => state.clearTask().copyWith(timerRunning: false));
      final subscription = ref.read(timerStreamProvider).subscription;
      //when the view is disposed
      //the subscription is null!
      //the way to stop the close is by closing the controller
      if (subscription == null) {
        ref.read(timerStreamProvider).controller.close();
      }

      ref.read(timerStreamProvider).subscription?.cancel();
      ref.read(timerStreamProvider).subscription = null;

      ref
          .read(selectTaskState.notifier)
          .update((state) => SelectTaskState(taskId: null));
    }
  }
}

class _AbandonButton extends StatelessWidget {
  const _AbandonButton(
      {super.key, required this.task, required this.onPressed});
  final VoidCallback onPressed;
  final Task task;
  @override
  Widget build(BuildContext context) {
    final color = task.status == TaskStatus.Abandoned.status
        ? const Color.fromARGB(255, 83, 83, 83)
        : const Color.fromARGB(255, 180, 80, 67);
    return Visibility(
      visible: task.status != TaskStatus.Completed.status,
      child: ElevatedButton(
          style: ButtonStyle(
              fixedSize: getProperty(const Size(115, 35)),
              backgroundColor: getProperty(color)),
          onPressed: onPressed,
          child: Text(task.status == TaskStatus.Abandoned.status
              ? 'Reactivar'
              : 'Abandonar')),
    );
  }

  MaterialStateProperty<T> getProperty<T>(T object) {
    return MaterialStateProperty.resolveWith((states) => object);
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton(
      {super.key,
      required this.task,
      required this.onPressed,
      required this.lightMode});
  final VoidCallback onPressed;
  final Task task;
  final bool lightMode;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: task.status != TaskStatus.Abandoned.status,
      child: ElevatedButton(
          style: ButtonStyle(
              fixedSize: getProperty(Size(115, 35)),
              backgroundColor: getProperty(lightMode
                  ? lateralBarBg
                  : const Color.fromARGB(255, 83, 83, 83))),
          onPressed: onPressed,
          child: Text(task.status == TaskStatus.Completed.status
              ? 'Reactivar'
              : 'Finalizar')),
    );
  }

  MaterialStateProperty<T> getProperty<T>(T object) {
    return MaterialStateProperty.resolveWith((states) => object);
  }
}

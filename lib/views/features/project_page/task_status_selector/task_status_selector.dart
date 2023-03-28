import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/task_status_enum.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/select_tasks_provider.dart';
import 'package:task_manager/provider/task_project_provider.dart';
import 'package:task_manager/provider/theme_provider.dart';
import 'package:task_manager/views/styles/app_colors.dart';

class TasksStatusSelector extends StatelessWidget {
  const TasksStatusSelector({
    super.key,
    required this.tasksBloc,
  });

  final TasksProjectBloc tasksBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TaskTypeSelector(
            taskStatus: TaskStatus.Pending,
            onTap: () {
              tasksBloc.changeSelectedStatus(status: TaskStatus.Pending);
            },
            icon: const Icon(
              Icons.square,
              color: Colors.yellow,
            ),
            text: 'Tareas pendientes'),
        TaskTypeSelector(
            taskStatus: TaskStatus.Completed,
            onTap: () {
              tasksBloc.changeSelectedStatus(status: TaskStatus.Completed);
            },
            icon: const Icon(
              Icons.square,
              color: Colors.green,
            ),
            text: 'Tareas completadas'),
        TaskTypeSelector(
            taskStatus: TaskStatus.Abandoned,
            onTap: () {
              tasksBloc.changeSelectedStatus(status: TaskStatus.Abandoned);
            },
            icon: const Icon(
              Icons.square,
              color: Colors.red,
            ),
            text: 'Tareas abandonadas'),
      ],
    );
  }
}

class TaskTypeSelector extends ConsumerWidget {
  const TaskTypeSelector(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.text,
      required this.taskStatus});
  final String text;
  final VoidCallback onTap;
  final Icon icon;
  final TaskStatus taskStatus;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightMode = !ref.read(themeState).darkMode;
    final taskOptionSelection =
        ref.read(tasksProjectState.select((value) => value.selectedStatus));
    final selectedColor = lightMode
        ? selectedTaskStatusBg
        : const Color.fromARGB(255, 61, 61, 61);
    final unselectedColor =
        lightMode ? unselectedTaskStatusBg : Color.fromARGB(246, 43, 40, 40);
    print('REBUILD TASK SELECTOROOO');
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 44,
            color: taskOptionSelection == taskStatus
                ? selectedColor
                : unselectedColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                icon,
                AutoSizeText(
                  text,
                  style: lightMode
                      ? Theme.of(context).textTheme.labelMedium
                      : null,
                ),
                const SizedBox(
                  width: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

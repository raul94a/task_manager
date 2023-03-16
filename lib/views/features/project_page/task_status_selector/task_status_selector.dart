import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/task_status_enum.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';

class TasksStatusSelector extends StatelessWidget {
  const TasksStatusSelector({
    required this.tasksBloc,
  });

  final TasksProjectBloc tasksBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TaskTypeSelector(
            onTap: () {
              tasksBloc.changeSelectedStatus(status: TaskStatus.Pending);
            },
            icon: const Icon(
              Icons.square,
              color: Colors.yellow,
            ),
            text: 'Tareas pendientes'),
        TaskTypeSelector(
            onTap: () {
              tasksBloc.changeSelectedStatus(status: TaskStatus.Completed);
            },
            icon: const Icon(
              Icons.square,
              color: Colors.green,
            ),
            text: 'Tareas completadas'),
        TaskTypeSelector(
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
      {super.key, required this.onTap, required this.icon, required this.text});
  final String text;
  final VoidCallback onTap;
  final Icon icon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 44,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                icon,
                AutoSizeText(text),
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

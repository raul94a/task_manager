import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/views/features/project_page/tasks/task_project_info.dart';
import 'package:task_manager/views/styles/gradients.dart';

class TaskList extends StatelessWidget {
  const TaskList(
      {super.key,
      required this.tasks,
      required this.projectPageRef,
      required this.lightMode});
  final bool lightMode;
  final WidgetRef projectPageRef;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
            // color: lightMode ? Colors.white : null
            gradient: lightMode ? lightModeGradient : null),
        child: Visibility(
          replacement: const Center(child: Text('No hay tareas que mostrar')),
          visible: tasks.isNotEmpty,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const _TasksTableHeaders(),
                const SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ProjectTaskInfo(
                      key: UniqueKey(),
                      task: task,
                      projectPageRef: projectPageRef,
                    );
                  },
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TasksTableHeaders extends StatelessWidget {
  const _TasksTableHeaders();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(left: 50),
          child: const AutoSizeText(
            'Nombre',
            textAlign: TextAlign.start,
          ),
        )),
        const Expanded(
            child: AutoSizeText(
          'Categoría',
          textAlign: TextAlign.start,
        )),
        const Expanded(
            child: AutoSizeText(
          'Usuario',
          textAlign: TextAlign.start,
        )),
        const Expanded(
            child: AutoSizeText(
          'Fecha',
          textAlign: TextAlign.start,
        ))
      ],
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/task_status_enum.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/project_provider.dart';

import 'package:task_manager/provider/task_project_provider.dart';
import 'package:uuid/uuid.dart';

class ProjectPage extends ConsumerWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProjectState = ref.watch(tasksProjectState);
    if (taskProjectState.tasks.isEmpty) {
      return Center(
        child: Column(
          children: [
            Text('Todavía no tienes ninguna tarea para este proyecto'),
            ElevatedButton(
                onPressed: () {
                  //TODO!
                  final bloc = TasksProjectBloc(ref: ref);
                  bloc.createTask(
                      task: Task(
                          id: Uuid().v4(),
                          name: 'Tarea de test',
                          category: 'Mobile',
                          projectId: taskProjectState.projectId!,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now()));
                },
                child: Text('Añadir tarea'))
          ],
        ),
      );
    }
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final project = ref
        .read(projectsState)
        .getProjectById(projectId: taskProjectState.projectId!);
    final tasks = taskProjectState.getTasksBySelectedStatus();
    final tasksBloc = TasksProjectBloc(ref: ref);
    print(taskProjectState);
    return Container(
      height: height,
      color: Colors.pink,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          AutoSizeText(project.name),
          const SizedBox(
            height: 20,
          ),
          Row(
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
                    tasksBloc.changeSelectedStatus(
                        status: TaskStatus.Completed);
                  },
                  icon: const Icon(
                    Icons.square,
                    color: Colors.green,
                  ),
                  text: 'Tareas completadas'),
              TaskTypeSelector(
                  onTap: () {
                    tasksBloc.changeSelectedStatus(
                        status: TaskStatus.Abandoned);
                  },
                  icon: const Icon(
                    Icons.square,
                    color: Colors.red,
                  ),
                  text: 'Tareas abandonadas'),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.lightBlue,
              child: Visibility(
                replacement: Center(child: Text('No hay tareas que mostrar')),
                visible: tasks.isNotEmpty,
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Text(tasks[index].name);
                  },
                ),
              ),
            ),
          )
        ],
      ),
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

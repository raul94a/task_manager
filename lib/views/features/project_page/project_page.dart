import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Text('Hay tarea hermano');
  }
}

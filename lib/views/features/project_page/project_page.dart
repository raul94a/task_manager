import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/project_provider.dart';
import 'package:task_manager/provider/task_project_provider.dart';
import 'package:task_manager/provider/timer_provider.dart';
import 'package:task_manager/views/features/project_page/task_status_selector/task_status_selector.dart';
import 'package:task_manager/views/features/project_page/task_timer/task_timer.dart';
import 'package:task_manager/views/features/project_page/tasks/task_list.dart';
import 'package:uuid/uuid.dart';

class ProjectPage extends ConsumerWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProjectState = ref.watch(tasksProjectState);
    print('Rebuilding Project Page');
    if (taskProjectState.tasks.isEmpty) {
      return _NoTasksForProject(taskProjectState: taskProjectState);
    }
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final project = ref
        .read(projectsState)
        .getProjectById(projectId: taskProjectState.projectId!);
    final tasks = taskProjectState.getTasksBySelectedStatus();
    final tasksBloc = TasksProjectBloc(ref: ref);

    return Container(
      height: height,
      color: Colors.pink,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(builder: (context, ref, _) {
                final task = ref.watch(timerState).task;
                Project projectTask = project;
                if (task != null) {
                  projectTask = ref
                      .read(projectsState)
                      .getProjectById(projectId: task.projectId);
                }
                return SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText('Proyecto ${projectTask.name}'),
                        if(task != null)AutoSizeText('Cronometrando la tarea ${task.name}')
                        
                      ]),
                );
              }),
              const TaskTimer()
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TasksStatusSelector(tasksBloc: tasksBloc),
          TaskList(
            tasks: tasks,
            projectPageRef: ref,
          )
        ],
      ),
    );
  }
}

class _NoTasksForProject extends ConsumerWidget {
  const _NoTasksForProject({
    required this.taskProjectState,
  });

  final TaskProjectStateProvider taskProjectState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text('Todavía no tienes ninguna tarea para este proyecto'),
        ElevatedButton(
            onPressed: () {
              //TODO!
              final bloc = TasksProjectBloc(ref: ref);
              bloc.createTask(
                  task: Task(
                      description: 'This is a good description',
                      id: const Uuid().v4(),
                      name: 'Tarea de test',
                      category: 'Mobile',
                      projectId: taskProjectState.projectId!,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now()));
            },
            child: const Text('Añadir tarea'))
      ],
    );
  }
}

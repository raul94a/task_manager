import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/core/extensions/context_extension.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/project_provider.dart';
import 'package:task_manager/provider/task_project_provider.dart';
import 'package:task_manager/provider/theme_provider.dart';
import 'package:task_manager/provider/timer_provider.dart';
import 'package:task_manager/views/features/lateral_bar/secondary_app_option/dialogs/add_task_dialog.dart';
import 'package:task_manager/views/features/project_page/task_status_selector/task_status_selector.dart';
import 'package:task_manager/views/features/project_page/task_timer/task_timer.dart';
import 'package:task_manager/views/features/project_page/tasks/task_list.dart';
import 'package:task_manager/views/styles/app_colors.dart';

class ProjectPage extends ConsumerWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsState.select((value) => value.projects));
    if(projects.isEmpty){
      return const Center(child: Text('No hay proyectos'),);
    }
    final taskProjectState = ref.watch(tasksProjectState);
    print('Rebuilding Project Page');
    final project = ref
        .read(projectsState)
        .getProjectById(projectId: taskProjectState.projectId!);
    if (taskProjectState.tasks.isEmpty) {
      return _NoTasksForProject(
          taskProjectState: taskProjectState, project: project);
    }
    final size = MediaQuery.of(context).size;
    final height = size.height;

    final tasks = taskProjectState.getTasksBySelectedStatus();
    final tasksBloc = TasksProjectBloc(ref: ref);
    final lightMode = !ref.read(themeState).darkMode;
    return Container(
      color: lightMode ? lateralBarBg : null,
      height: height,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer(builder: (context, ref, _) {
                final task = ref.watch(timerState).task;
                Project projectTask = project;
                if (task != null) {
                  projectTask = ref
                      .read(projectsState)
                      .getProjectById(projectId: task.projectId);
                }
                return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AutoSizeText('Proyecto ${projectTask.name}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 23)),
                      if (task != null)
                        AutoSizeText('Cronometrando la tarea ${task.name}',style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 32)),
                    ]);
              }),
              const TaskTimer()
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TasksStatusSelector(tasksBloc: tasksBloc),
          TaskList(
            lightMode: lightMode,
            tasks: tasks,
            projectPageRef: ref,
          )
        ],
      ),
    );
  }
}

class _NoTasksForProject extends ConsumerWidget {
  const _NoTasksForProject(
      {required this.taskProjectState, required this.project});

  final TaskProjectStateProvider taskProjectState;
  final Project project;
  static const double svgSize = 125.0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = context.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SvgPicture.asset(
              'assets/pin.svg',
              width: svgSize,
              height: svgSize,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              
              padding: const EdgeInsets.all(25),
             
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 39, 39),
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: width * 0.2,
              constraints: BoxConstraints(maxWidth: 800),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Todavía no tienes ninguna tarea para este proyecto',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.resolveWith(
                                (states) => Size(context.width * 0.2 *0.95, 35)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => const Color.fromARGB(255, 63, 63, 63))),
                        onPressed: () {
                          //TODO!
                          showDialog(
                              context: context,
                              builder: (_) => AddTaskDialog(project: project));
                        },
                        child: const Text('Añadir tarea'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

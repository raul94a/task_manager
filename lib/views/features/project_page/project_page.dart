import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/core/extensions/context_extension.dart';
import 'package:task_manager/core/extensions/ref_extensions.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/project_provider.dart';
import 'package:task_manager/provider/task_project_provider.dart';
import 'package:task_manager/provider/theme_provider.dart';
import 'package:task_manager/provider/timer_provider.dart';
import 'package:task_manager/provider/timer_stream.provider.dart';
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
    if (projects.isEmpty) {
      return const Center(
        child: Text('No hay proyectos'),
      );
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
          Stack(
            children: [
              Positioned(
                  left: 5, top: 0, child: _AddTaskButton(project: project)),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              AutoSizeText('Proyecto ${projectTask.name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontSize: 23,
                                          color:
                                              lightMode ? Colors.white : null)),
                            ],
                          ),
                          if (task != null)
                            SizedBox(
                              width: context.width * 0.4,
                              child: AutoSizeText(task.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontSize: 28,
                                          color:
                                              lightMode ? Colors.white : null)),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (task != null)
                            Consumer(builder: (ctx, ref, _) {
                              final streamState =
                                  ref.watch(timerStreamProvider);
                              if (streamState.subscription == null) {
                                return Text(
                                  'Estado: cronómetro parado.',
                                  style: context.bodyMedium?.copyWith(
                                      color: Colors.white, fontSize: 16.0),
                                );
                              } else if (streamState.subscription != null &&
                                  streamState.subscription!.isPaused) {
                                return Text(
                                  'Estado: cronómetro pausado.',
                                  style: context.bodyMedium?.copyWith(
                                      color: Colors.white, fontSize: 16.0),
                                );
                              } else {
                                return Text(
                                  'Estado: cronómetro en marcha.',
                                  style: context.bodyMedium?.copyWith(
                                      color: Colors.white, fontSize: 16.0),
                                );
                              }
                            })
                        ]);
                  }),
                  const TaskTimer()
                ],
              ),
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

class _AddTaskButton extends ConsumerStatefulWidget {
  const _AddTaskButton({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  ConsumerState<_AddTaskButton> createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends ConsumerState<_AddTaskButton> {
  late Color hoveredColor;
  bool isHover = false;
  late bool lightMode;
  changeHoverStatus() => setState(() => isHover = !isHover);
  @override
  void initState() {
    lightMode = ref.lightMode;
    hoveredColor = lightMode ? lightSelectedMainOptionColor : darkSelectedMainOptionColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        changeHoverStatus();
      },
      onExit: (event) {
        changeHoverStatus();
      },
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        decoration: BoxDecoration(
          color: !lightMode ? Colors.black : lateralBarBg
        ),
        message: 'Añadir tarea a ${widget.project.name}',
        child: GestureDetector(
          onTap: () => showDialog(
              context: context,
              builder: (_) => AddTaskDialog(project: widget.project)),
          child: Icon(
            Icons.add,
            color: isHover ? hoveredColor : null,
            size: 50,
          ),
        ),
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
    final lightMode = ref.lightMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(project.name,
                style: context.bodyMedium?.copyWith(fontSize: 34)),
            const SizedBox(
              height: 20,
            ),
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
                color: lightMode
                    ? lateralBarBg
                    : const Color.fromARGB(255, 39, 39, 39),
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: width * 0.2,
              constraints: const BoxConstraints(maxWidth: 800),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Todavía no tienes ninguna tarea para este proyecto',
                        textAlign: TextAlign.center,
                        style: context.bodyMedium
                            ?.copyWith(color: lightMode ? Colors.white : null)),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.resolveWith(
                                (states) =>
                                    Size(context.width * 0.2 * 0.95, 35)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => lightMode
                                    ? noTaskElevatedBtnLightColor
                                    : const Color.fromARGB(255, 63, 63, 63))),
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

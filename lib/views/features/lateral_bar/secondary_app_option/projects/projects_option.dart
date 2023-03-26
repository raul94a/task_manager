import 'package:auto_size_text/auto_size_text.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/mixins/material_state_property_mixin.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/select_tasks_provider.dart';
import 'package:task_manager/provider/timer_provider.dart';
import 'package:task_manager/provider/timer_stream.provider.dart';
import 'package:task_manager/views/features/lateral_bar/secondary_app_option/dialogs/add_task_dialog.dart';
import 'package:task_manager/views/features/lateral_bar/secondary_app_option/dialogs/delete_project_dialog.dart';
import 'package:task_manager/views/features/lateral_bar/secondary_app_option/projects/create_new_project.dart';

class ProjectsOption extends StatelessWidget {
  const ProjectsOption({
    super.key,
    required this.secondaryContainerWidth,
    required this.projects,
  });

  final double secondaryContainerWidth;
  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateNewProject(secondaryContainerWidth: secondaryContainerWidth),
        Expanded(
          child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (ctx, index) => _ProjectTaskOption(
                  key: UniqueKey(), project: projects[index])),
        ),
      ],
    );
  }
}

class _ProjectTaskOption extends ConsumerStatefulWidget {
  const _ProjectTaskOption({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  ConsumerState<_ProjectTaskOption> createState() => _ProjectTaskOptionState();
}

class _ProjectTaskOptionState extends ConsumerState<_ProjectTaskOption>
    with SingleTickerProviderStateMixin {
  bool isTextHovered = false;
  bool edit = false;

  enableEdit() => setState(() => {edit = true, nameFocus.requestFocus()});
  disableEdit() => setState(() => edit = false);

  onHover() => setState(() {
        isTextHovered = true;
        controller.forward();
      });
  onExit() {
    controller.reverse().whenComplete(() {
      setState(() {
        isTextHovered = false;
      });
    });
  }

  final nameController = TextEditingController();
  final nameFocus = FocusNode();

  late AnimationController controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: Duration.zero);

  late Animation<double> opacityAnimation =
      Tween<double>(begin: 127.0, end: 255.0)
          .chain(CurveTween(curve: Curves.easeInExpo))
          .animate(controller);

  @override
  void initState() {
    super.initState();
    nameController.text = widget.project.name;
  }

  @override
  void dispose() {
    controller.dispose();
    nameController.dispose();
    nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('tap on ${widget.project.name}');
        final tasksProjectBloc = TasksProjectBloc(ref: ref);
        tasksProjectBloc.getByProject(widget.project.id);

         final timerStreamState = ref.read(timerStreamProvider);
        final timerProvider = ref.watch(timerState);

        if ((timerStreamState.subscription != null &&
                timerStreamState.subscription!.isPaused) ||
            timerProvider.timerRunning) {
          return;
        }
        print('clearing task state');
        ref
            .read(selectTaskState.notifier)
            .update((state) => state.copyWith(taskId: null));
        ref.read(timerState.notifier).update((state) => state.clearTask());
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (ctx, _) => Container(
          color: isTextHovered
              ? Color.fromARGB(opacityAnimation.value.toInt(), 207, 207, 207)
              : Colors.white,
          key: widget.key,
          padding: const EdgeInsets.all(8.0),
          child: MouseRegion(
            onEnter: (_) => onHover(),
            onExit: (_) => onExit(),
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: !edit,
                  replacement: Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: nameFocus,
                            controller: nameController,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {
                              if (nameController.text.isEmpty) {
                                disableEdit();
                                return;
                              }
                              ProjectBloc(ref: ref, context: context)
                                  .updateProject(
                                      project: widget.project
                                          .copyWith(name: nameController.text));
                              disableEdit();
                            
                            },
                            icon: const Icon(Icons.check))
                      ],
                    ),
                  ),
                  child: AutoSizeText(
                    widget.project.name,
                    minFontSize: 8,
                    maxLines: 2,
                    group: AutoSizeGroup(),
                    overflow: TextOverflow.fade,
                  ),
                ),
                Visibility(
                  visible: !edit,
                  child: ContextMenuRegion(
                    contextMenu: const Center(),
                    child: IconButton(
                        onPressed: () {
                          context.contextMenuOverlay.show(_ContextMenuProjectTask(
                              project: widget.project,
                              enableEditHandler: enableEdit));
                        },
                        icon: const Icon(Icons.more_horiz_outlined)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContextMenuProjectTask extends StatelessWidget
    with MaterialStatePropertyMixin {
  const _ContextMenuProjectTask(
      {super.key, required this.project, required this.enableEditHandler});

  final Project project;
  final VoidCallback enableEditHandler;
  static const borderRadius = 8.0;
  static const columnPadding = 8.0;
  static const containerBorderWidth = .6;
  static const optionSpace = 5.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 204, 201, 201),
              width: containerBorderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(columnPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //add
            TextButton.icon(
                style: ButtonStyle(
                  padding: getProperty(EdgeInsets.zero),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AddTaskDialog(
                          project: project,
                        );
                      });
                  context.contextMenuOverlay.hide();
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                label: const Text('Añadir tarea')),
            const SizedBox(
              height: optionSpace,
            ),
            //edit
            TextButton.icon(
                style: ButtonStyle(
                  padding: getProperty(EdgeInsets.zero),
                ),
                onPressed: () {
                  enableEditHandler();
                  context.contextMenuOverlay.hide();
                },
                icon: const Icon(Icons.mode, color: Colors.black),
                label: Text('Editar ${project.name}')),
            const SizedBox(
              height: optionSpace,
            ),
            //delete
            TextButton.icon(
                style: ButtonStyle(
                  padding: getProperty(EdgeInsets.zero),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => DeleteProjectDialog(project: project));

                  context.contextMenuOverlay.hide();
                },
                icon: const Icon(Icons.remove, color: Colors.black),
                label: Text('Borrar ${project.name}'))
          ],
        ),
      ),
    );
  }
}

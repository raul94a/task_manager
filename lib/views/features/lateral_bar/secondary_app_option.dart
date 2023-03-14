import 'package:auto_size_text/auto_size_text.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/main_option_enum.dart';
import 'package:task_manager/core/mixins/material_state_property_mixin.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/provider/main_option_provider.dart';
import 'package:task_manager/provider/project_provider.dart';

class SecondaryAppOption extends ConsumerWidget {
  const SecondaryAppOption({super.key, required this.secondaryContainerWidth});

  final double secondaryContainerWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainOpt = ref.watch(mainOptionState);
    final option = mainOpt.selectedOptionFromMainMenu;

    if (option == MainOption.projects) {
      final projects = ref.watch(projectsState).projects;
      return _ProjectsOption(
          secondaryContainerWidth: secondaryContainerWidth, projects: projects);
    } else if (option == MainOption.stats) {
      return const Text('stats');
    }
    return const Text('Settings');
  }
}

class _ProjectsOption extends StatelessWidget {
  const _ProjectsOption({
    super.key,
    required this.secondaryContainerWidth,
    required this.projects,
  });

  final double secondaryContainerWidth;
  final List<Project> projects;

  void _createProjectDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return const _CreateProjectDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    print('Re building _Projects option');
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: secondaryContainerWidth * 0.6,
                child: AutoSizeText(
                  'Añadir nuevo proyecto',
                  minFontSize: 8,
                  maxLines: 4,
                  group: AutoSizeGroup(),
                  overflow: TextOverflow.fade,
                ),
              ),
              IconButton(
                  onPressed: () => _createProjectDialog(context),
                  icon: Icon(Icons.add))
            ],
          ),
        ),
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

class _ProjectTaskOption extends StatelessWidget {
  const _ProjectTaskOption({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(project.name),
          ContextMenuRegion(
            contextMenu: const Center(),
            child: IconButton(
                onPressed: () {
                  context.contextMenuOverlay
                      .show(_ContextMenuProjectTask(project: project));
                },
                icon: const Icon(Icons.more_horiz_outlined)),
          )
        ],
      ),
    );
  }
}

class _ContextMenuProjectTask extends StatelessWidget
    with MaterialStatePropertyMixin {
  const _ContextMenuProjectTask({super.key, required this.project});

  final Project project;

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
                onPressed: () {},
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
                onPressed: () {},
                icon: Icon(Icons.mode, color: Colors.black),
                label: Text('Editar ${project.name}')),
            const SizedBox(
              height: optionSpace,
            ),
            //delete
            TextButton.icon(
                style: ButtonStyle(
                  padding: getProperty(EdgeInsets.zero),
                ),
                onPressed: () {},
                icon: const Icon(Icons.remove, color: Colors.black),
                label: Text('Borrar ${project.name}'))
          ],
        ),
      ),
    );
  }
}

class _CreateProjectDialog extends ConsumerStatefulWidget {
  const _CreateProjectDialog({
    super.key,
  });

  @override
  ConsumerState<_CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<_CreateProjectDialog>
    with MaterialStatePropertyMixin {
  bool buttonEnabled = false;
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  enableButton() => setState(() => buttonEnabled = true);
  disableButton() => setState(() => buttonEnabled = false);

  @override
  void dispose() {
    controller.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Introduce el nombre del nuevo proyecto'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: formKey,
              child: TextFormField(
                validator: validator,
                controller: controller,
                onChanged: onChanged,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(192, 219, 221, 221),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlue),
                    ),
                    errorMaxLines: 2,
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red))),
              ),
            )),
            const SizedBox(
              width: 6,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  fixedSize: getProperty(const Size(120, 50)),
                ),
                onPressed: !buttonEnabled ? null : _createProject,
                child: Text('Crear'))
          ],
        )
      ],
    );
  }

  void _createProject() {
    final text = controller.text;
    if (!formKey.currentState!.validate()) {
      return;
    }
    ProjectBloc(context: context, ref: ref).createProject(text);
    Navigator.of(context).pop();
  }

  void onChanged(String str) {
    if (controller.text.isEmpty && buttonEnabled) {
      disableButton();
    } else if (controller.text.isNotEmpty && !buttonEnabled) {
      enableButton();
    }
  }

  String? validator(String? value) {
    if (value == null || value.length < 2) {
      return 'El nombre del proyecto debe tener al menos dos caracteres';
    }
    return null;
  }
}

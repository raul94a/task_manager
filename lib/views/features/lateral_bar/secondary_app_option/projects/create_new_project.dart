import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/extensions/context_extension.dart';
import 'package:task_manager/core/extensions/ref_extensions.dart';
import 'package:task_manager/core/mixins/material_state_property_mixin.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/provider/project_provider.dart';
import 'package:task_manager/provider/task_project_provider.dart';
import 'package:task_manager/provider/theme_provider.dart';
import 'package:task_manager/views/styles/app_colors.dart';

class CreateNewProject extends StatefulWidget {
  const CreateNewProject({super.key, required this.secondaryContainerWidth});
  final double secondaryContainerWidth;
  @override
  State<CreateNewProject> createState() => _CreateNewProjectState();
}

class _CreateNewProjectState extends State<CreateNewProject> {
  void _createProjectDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) {
          return const CreateProjectDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
      child: Consumer(
        builder: (ctx, ref, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: widget.secondaryContainerWidth * 0.6,
              child: AutoSizeText(
                'Añadir nuevo proyecto',
                minFontSize: 8,
                maxLines: 4,
                group: AutoSizeGroup(),
                overflow: TextOverflow.fade,
                style: !ref.read(themeState).darkMode
                    ? Theme.of(context).textTheme.labelMedium
                    : null,
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () => _createProjectDialog(context),
                icon: const Icon(Icons.add),
                color: !ref.read(themeState).darkMode ? Colors.white : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CreateProjectDialog extends ConsumerStatefulWidget {
  const CreateProjectDialog({
    super.key,
  });

  @override
  ConsumerState<CreateProjectDialog> createState() =>
      _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<CreateProjectDialog>
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
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.0),
      title: Text(
        'Introduce el nombre del nuevo proyecto',
        style: context.bodyMedium
            ?.copyWith(color: ref.lightMode ? Colors.white : null),
      ),
      content: SizedBox(width: size.width * 0.35),
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
              ),
            )),
            const SizedBox(
              width: 6,
            ),
            ElevatedButton(
            
              style: ButtonStyle(
                fixedSize: getProperty(const Size(120, 50)),
                                
                backgroundColor: getProperty(ref.lightMode ? lateralBarBg:null ),
              ),
              onPressed: !buttonEnabled ? null : _createProject,
              child: Text(
                'Crear',
                style: context.bodyMedium
                    ?.copyWith(color: ref.lightMode ? Colors.white : null),
              ),
            )
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

    ProjectBloc(context: context, ref: ref).createProject(text).then((project) {
      final projects = ref.read(projectsState).projects;
      if (projects.length == 1) {
        TasksProjectBloc(ref: ref).setProjectId(project!.id);
      }
    }).catchError((err, stack) {
      return null;
    });
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

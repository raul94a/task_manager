import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/mixins/material_state_property_mixin.dart';
import 'package:task_manager/logic/project_bloc.dart';

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
      child: Row(
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
            ),
          ),
          IconButton(
              onPressed: () => _createProjectDialog(context),
              icon: const Icon(Icons.add))
        ],
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
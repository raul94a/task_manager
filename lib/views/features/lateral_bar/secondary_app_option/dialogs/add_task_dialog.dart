import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:task_manager/core/extensions/context_extension.dart';
import 'package:task_manager/core/extensions/ref_extensions.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:task_manager/views/styles/app_colors.dart';
import 'package:task_manager/views/styles/form_decoration.dart';
import 'package:uuid/uuid.dart';

class AddTaskDialog extends ConsumerStatefulWidget {
  const AddTaskDialog({super.key, required this.project});
  final Project project;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTaskDialog> {
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14),
      child: SizedBox(
        width: size.width * 0.6,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  'Añadir tarea al proyecto ${widget.project.name}',
                  style: context.bodyMedium?.copyWith(
                      color: ref.lightMode ? Colors.white : null,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    //Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre',
                            style: context.bodyMedium?.copyWith(
                                color: ref.lightMode ? Colors.white : null),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El nombre no puede estar vacío';
                              }
                              return null;
                            },
                            // decoration: getDecoration(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    //Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categoría',
                            style: context.bodyMedium?.copyWith(
                                color: ref.lightMode ? Colors.white : null),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: categoryController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'La categoría no puede estar vacía';
                              }
                              return null;
                            },
                            // decoration: getDecoration(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Descripción',
                  style: context.bodyMedium
                      ?.copyWith(color: ref.lightMode ? Colors.white : null),
                ),
                Container(
                  decoration: ref.lightMode
                      ? null
                      : const BoxDecoration(
                          image: DecorationImage(
                              image: Svg('assets/taskbg.svg',
                                  color: Color.fromARGB(255, 255, 244, 147)))),
                  child: TextFormField(
                    maxLines: 15,
                    controller: descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La descripción no puede estar vacía';
                      }
                      return null;
                    },
                    //decoration: getDecoration(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.red),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.resolveWith(
                                (states) => Size(115, 35)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) => ref.lightMode
                                    ? lateralBarBg
                                    : Color.fromARGB(255, 63, 63, 63))),
                        onPressed: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          final now = DateTime.now();
                          final task = Task(
                            id: const Uuid().v4(),
                            name: nameController.text,
                            description: descriptionController.text,
                            category: categoryController.text,
                            projectId: widget.project.id,
                            createdAt: now,
                            updatedAt: now,
                          );
                          Navigator.of(context).pop();
                          TasksProjectBloc(ref: ref).createTask(task: task);
                        },
                        child: const Text('Añadir tarea')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

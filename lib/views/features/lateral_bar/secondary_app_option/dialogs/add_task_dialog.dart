import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
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

  InputDecoration getDecoration() {
    return const InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0.75),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 0.75),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0.75),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0.75),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: EdgeInsets.zero,
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
                  'Añadir tarea al projecto ${widget.project.name}',
                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
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
                          Text('Nombre'),
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
                            decoration: getDecoration(),
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
                          Text('Categoría'),
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
                            decoration: getDecoration(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text('Descripción'),
                
                TextFormField(
                  maxLines: 15,
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La descripción no puede estar vacía';
                    }
                    return null;
                  },
                  decoration: getDecoration(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      
                        onPressed: Navigator.of(context).pop,
                        child: const Text('Cancelar',style: TextStyle(color: Colors.red),)),
                    const SizedBox(width: 20,),
                    ElevatedButton(
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
                          TasksProjectBloc(ref: ref).createTask(task: task);
                          Navigator.of(context).pop();
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
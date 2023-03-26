import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/logic/tasks_project_bloc.dart';
import 'package:uuid/uuid.dart';

class DeleteProjectDialog extends ConsumerStatefulWidget {
  const DeleteProjectDialog({super.key, required this.project});
  final Project project;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<DeleteProjectDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text('¿Quieres borrar el proyecto ${widget.project.name}?'),
      actions: [
        ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: Text('No, salir')),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith((states) => Colors.red)),
            onPressed: () {
              ProjectBloc(ref: ref, context: context)
                  .deleteProject(widget.project);
              Navigator.of(context).pop();
            },
            child: Text('Sí, borrar')),
      ],
    );
  }
}

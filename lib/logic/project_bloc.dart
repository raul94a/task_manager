import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/data/repositories/project_repository.dart';
import 'package:task_manager/provider/project_provider.dart';
import 'package:uuid/uuid.dart';

class ProjectBloc {
  final WidgetRef ref;
  final BuildContext context;
  final ProjectRepository repository = ProjectRepository();
  ProjectBloc({required this.ref, required this.context});

  Future<List<Project>> getProjects() async {
    print('Triggering getProjects');
    //empezamos cambiando el state a loading... envuelvo al resto en un Future.delayed
    //para que se vea bien la actualización del estado
   

    final notifier = ref.read(projectsState);
    try {
      final projects = await repository.getAll();
      notifier.projects = [...projects];
      return projects;
    } catch (ex) {
      
      rethrow;
    }
  }

  Future<void> createProject(String name) async {
    final notifier = ref.read(projectsState.notifier);

    notifier.update((state) => state.copyWith(isError: false, isLoading: true));

    try {
      final id = const Uuid().v4();
      final date = DateTime.now();
      final project =
          Project(id: id, name: name, createdAt: date, updatedAt: date);
      await repository.create(project);
      final projects = notifier.state.projects;
      projects.add(project);
      notifier.update((state) => state
          .copyWith(projects: [...projects], isError: false, isLoading: false));
    } catch (ex) {
      notifier.update((state) => state.copyWith(isError: true));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/data/repositories/project_repository.dart';
import 'package:task_manager/provider/project_provider.dart';

class ProjectBloc {
  final WidgetRef ref;
  final BuildContext context;
  final ProjectRepository repository = ProjectRepository();
  ProjectBloc({required this.ref, required this.context});

  Future<void> getProjects() async {
    print('Triggering getProjects');
    //empezamos cambiando el state a loading... envuelvo al resto en un Future.delayed
    //para que se vea bien la actualización del estado
    ref.read(projectsState.notifier).update(
          (state) => state.copyWith(isLoading: true),
        );

    final notifier = ref.read(projectsState.notifier);
    try {
      final projects = await repository.getAll();
      notifier.update((state) =>
          state.copyWith(projects: projects, isError: false, isLoading: false));
    } catch (ex) {
      notifier.update((state) => state.copyWith(isError: true));
    }
  }

  Future<void> createProject(Project project) async {
    final notifier = ref.read(projectsState.notifier);

    try {
      final createdProject = await repository.create(project);
      final projects = notifier.state.projects;
      projects.add(createdProject);
      notifier.update((state) => state
          .copyWith(projects: [...projects], isError: false, isLoading: false));
    } catch (ex) {
      notifier.update((state) => state.copyWith(isError: true));
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/project_model.dart';

final projectStateNotifierProvider =
    StateNotifierProvider((ref) => ref.read(projectsState.notifier));

final projectsState = StateProvider(((ref) {
  final ProjectStateProvider projectProvider = ProjectStateProvider();

  ref.onDispose(() {
    print('============================================');
    print('DISPOSING SERVERAL THINGS');
    print('============================================');
  });

  return projectProvider;
}));

class ProjectStateProvider {
  bool isLoading;
  bool isError;
  List<Project> projects;

  ProjectStateProvider({
    this.isError = false,
    this.projects = const [],
    this.isLoading = false,
  });

  ProjectStateProvider copyWith(
      {bool? isLoading, bool? isError, List<Project>? projects}) {
    return ProjectStateProvider(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      projects: projects ?? this.projects,
    );
  }

  @override
  String toString() {
    return 'AuthStateProvider(isLoading: $isLoading, isError: $isError, i)';
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/task_model.dart';

final tasksProjectNotifierProvider =
    StateNotifierProvider((ref) => ref.read(tasksProjectState.notifier));

final tasksProjectState = StateProvider(((ref) {
  final TaskProjectStateProvider tasksProjectProvider = TaskProjectStateProvider();

  ref.onDispose(() {
    print('============================================');
    print('DISPOSING SERVERAL THINGS');
    print('============================================');
  });

  return tasksProjectProvider;
}));

class TaskProjectStateProvider {
  bool isLoading;
  bool isError;
  String? projectId;
  List<Task> tasks = [];

  TaskProjectStateProvider({
    this.isError = false,
    List<Task>? tasks,
    this.projectId,
    this.isLoading = false,
  }){
    this.tasks = tasks ?? [];
  }

  TaskProjectStateProvider copyWith(
      {bool? isLoading, bool? isError, List<Task>? tasks, String? projectId}) {
    return TaskProjectStateProvider(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      projectId: projectId ?? this.projectId,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  String toString() {
    return 'AuthStateProvider(isLoading: $isLoading, isError: $isError, i)';
  }
}

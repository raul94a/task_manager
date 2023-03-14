// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager/core/enums/task_status_enum.dart';
import 'package:task_manager/data/models/task_model.dart';

final tasksProjectNotifierProvider =
    StateNotifierProvider((ref) => ref.read(tasksProjectState.notifier));

final tasksProjectState = StateProvider(((ref) {
  final TaskProjectStateProvider tasksProjectProvider =
      TaskProjectStateProvider();

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
  TaskStatus selectedStatus;

  TaskProjectStateProvider({
    this.isError = false,
    this.selectedStatus = TaskStatus.Pending,
    List<Task>? tasks,
    this.projectId,
    this.isLoading = false,
  }) {
    this.tasks = tasks ?? [];
  }

  TaskProjectStateProvider copyWith({
    bool? isLoading,
    bool? isError,
    List<Task>? tasks,
    String? projectId,
    TaskStatus? selectedStatus,
  }) {
    print(selectedStatus);
    return TaskProjectStateProvider(
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        projectId: projectId ?? this.projectId,
        tasks: tasks ?? this.tasks,
        selectedStatus: selectedStatus ?? this.selectedStatus);
  }

  List<Task> getTasksBySelectedStatus() {
    return tasks
        .where((element) => element.status == selectedStatus.status)
        .toList();
  }

 

  @override
  String toString() {
    return 'TaskProjectStateProvider(isLoading: $isLoading, isError: $isError, projectId: $projectId, tasks: $tasks, selectedStatus: $selectedStatus)';
  }
}

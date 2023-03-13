import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/task_status_enum.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/provider/task_project_provider.dart';

class TasksProjectBloc {
  TasksProjectBloc({required this.ref});

  final WidgetRef ref;
  final taskRepository = TaskRepository();

  void setProjectId(String projectId) {
    final notifier = ref.read(tasksProjectState);
    notifier.projectId = projectId; 
  }
  Future<void> loadTasks() async {
    final notifier = ref.read(tasksProjectState);
   

    try {
      final tasksDB =
          await taskRepository.getAll(notifier.projectId ?? '');
      notifier.tasks = [...tasksDB];
    } catch (ex) {
      rethrow;
      // notifier.update((state) =>
      //     state.copyWith(isError: true, isLoading: false, tasks: []));
    }
  }

  Future<void> getByProject() async {
    final notifier = ref.read(tasksProjectState.notifier);
    notifier.update((state) => state.copyWith(isError: false, isLoading: true));

    try {
      final tasksDB =
          await taskRepository.getAll(notifier.state.projectId ?? '');
      notifier.update((state) => state
          .copyWith(isError: false, isLoading: false, tasks: [...tasksDB]));
    } catch (ex) {
      notifier.update((state) =>
          state.copyWith(isError: true, isLoading: false, tasks: []));
    }
  }

  Future<List<Task>> filterByStatus({required TaskStatus status}) async {
    final value = status.status;
    final tasks = ref.read(tasksProjectState).tasks;
    return tasks.where((element) => element.status == value).toList();
  }

  Future<void> createTask({required Task task}) async {
    final notifier = ref.read(tasksProjectState.notifier);
    notifier.update((state) => state.copyWith(isError: false, isLoading: true));

    try {
      await taskRepository.create(task);
      final isSelectedProject = notifier.state.projectId == task.projectId;
      if (isSelectedProject) {
        final tasks = notifier.state.tasks;
        tasks.add(task);
        notifier.update((state) => state
            .copyWith(isError: false, isLoading: false, tasks: [...tasks]));
      }
    } catch (ex) {
      notifier.update((state) =>
          state.copyWith(isError: true, isLoading: false, tasks: []));
    }
  }
}

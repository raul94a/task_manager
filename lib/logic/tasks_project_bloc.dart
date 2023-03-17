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
      final tasksDB = await taskRepository.getAll(notifier.projectId ?? '');
      notifier.tasks = [...tasksDB];
    } catch (ex) {
      rethrow;
      // notifier.update((state) =>
      //     state.copyWith(isError: true, isLoading: false, tasks: []));
    }
  }

  Future<void> getByProject(String projectId) async {
    final notifier = ref.read(tasksProjectState.notifier);
    notifier.update((state) =>
        state.copyWith(isError: false, isLoading: true, projectId: projectId));

    try {
      final tasksDB = await taskRepository.getAll(projectId);
      print(tasksDB);
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
    print('Creating task');
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

  void updateTask({required Task task}) {
    final state = ref.read(tasksProjectState);
    final tasks = state.tasks;
    final index = tasks.indexWhere((element) => element.id == task.id);
    try {
      tasks[index] = task;
      final notifier = ref.read(tasksProjectState.notifier);
      notifier.update((state) => state.copyWith(tasks: [...tasks]));
    } catch (ex) {
      print(ex);
    }
  }

  void changeSelectedStatus({required TaskStatus status}) {
    final notifier = ref.read(tasksProjectState.notifier);
    print(status);
    notifier.update(
        (state) => state.copyWith(selectedStatus: status, isError: false));
    print('State changed ${notifier.state}');
  }
}

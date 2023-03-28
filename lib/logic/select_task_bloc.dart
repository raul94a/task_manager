import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/provider/select_tasks_provider.dart';

class SelectTaskBloc{
  final WidgetRef ref;


  const SelectTaskBloc({required this.ref});


  void clearSelectedTask(){
    ref.read(selectTaskState.notifier).update((state) => SelectTaskState());
  }

  void setTask(Task task){
     ref
          .read(selectTaskState.notifier)
          .update((state) => state = SelectTaskState(taskId: task.id));
  }
  
}
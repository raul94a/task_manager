// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectTaskStateNotifierProvider =
    StateNotifierProvider((ref) => ref.read(selectTaskState.notifier));

final selectTaskState = StateProvider(((ref) {
  final SelectTaskState mainOptionProvider =  SelectTaskState();

  ref.onDispose(() {
    print('============================================');
    print('DISPOSING SERVERAL THINGS');
    print('============================================');
  });

  return mainOptionProvider;
}));
class SelectTaskState {

  String? taskId;
  SelectTaskState({this.taskId});

  @override
  String toString() => 'SelectTaskState(taskId: $taskId)';

  SelectTaskState copyWith({
    String? taskId,
  }) {
    return SelectTaskState(
      taskId: taskId
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/main_option_enum.dart';
import 'package:task_manager/provider/main_option_provider.dart';

class MainOptionBloc {
  const MainOptionBloc({required this.ref});
  final WidgetRef ref;

  changeOption({required MainOption option}){
    final notifier = ref.read(mainOptionState.notifier);
    notifier.update((state) => state.copyWith(selectedOptionFromMainMenu: option));

    print('Main option changed to ${option.value}');
  }

}
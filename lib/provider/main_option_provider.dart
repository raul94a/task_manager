// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager/core/enums/main_option_enum.dart';

final mainOptionStateNotifierProvider =
    StateNotifierProvider((ref) => ref.read(mainOptionState.notifier));

final mainOptionState = StateProvider(((ref) {
  final MainOptionStateProvider mainOptionProvider =  MainOptionStateProvider();

  ref.onDispose(() {
    print('============================================');
    print('DISPOSING SERVERAL THINGS');
    print('============================================');
  });

  return mainOptionProvider;
}));

class MainOptionStateProvider {
  final MainOption selectedOptionFromMainMenu;

  const MainOptionStateProvider(
      {this.selectedOptionFromMainMenu = MainOption.projects});

  MainOptionStateProvider copyWith({
    MainOption? selectedOptionFromMainMenu,
  }) {
    return MainOptionStateProvider(
      selectedOptionFromMainMenu:
          selectedOptionFromMainMenu ?? this.selectedOptionFromMainMenu,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeStateNotifier = StateNotifierProvider((ref) => ref.read(themeState.notifier));


final themeState = StateProvider((ref) => ThemeState(darkMode: true));


class ThemeState {
  final bool darkMode; 
  ThemeState({
    required this.darkMode,
  });

  ThemeState copyWith({
    bool? darkMode,
  }) {
    return ThemeState(
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  String toString() => 'ThemeState(darkMode: $darkMode)';
}

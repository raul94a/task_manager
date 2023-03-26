import 'package:auto_size_text/auto_size_text.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/main_option_enum.dart';
import 'package:task_manager/core/mixins/material_state_property_mixin.dart';
import 'package:task_manager/data/models/project_model.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/provider/main_option_provider.dart';
import 'package:task_manager/provider/project_provider.dart';
import 'package:task_manager/views/features/lateral_bar/secondary_app_option/projects/projects_option.dart';

class SecondaryAppOption extends ConsumerWidget {
  const SecondaryAppOption({super.key, required this.secondaryContainerWidth});

  final double secondaryContainerWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainOpt = ref.watch(mainOptionState);
    final option = mainOpt.selectedOptionFromMainMenu;

    if (option == MainOption.projects) {
      final projects = ref.watch(projectsState).projects;
      print('Building projects option');
      print(projects);
      return ProjectsOption(
          secondaryContainerWidth: secondaryContainerWidth, projects: projects);
    } else if (option == MainOption.stats) {
      return const Text('stats');
    }
    return const Text('Settings');
  }
}




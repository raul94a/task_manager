import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/main_option_enum.dart';
import 'package:task_manager/provider/main_option_provider.dart';
import 'package:task_manager/provider/project_provider.dart';

class SecondaryAppOption extends ConsumerWidget {
  const SecondaryAppOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainOpt = ref.watch(mainOptionState);
    final option = mainOpt.selectedOptionFromMainMenu;
    if (option == MainOption.projects) {
      final projects = ref.read(projectsState).projects;
      return ListView.builder(
          itemCount: projects.length,
          itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(projects[index].name),
                    
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_horiz_outlined))
                  ],
                ),
              ));
    } else if (option == MainOption.stats) {
      return const Text('stats');
    }
    return const Text('Settings');
  }
}

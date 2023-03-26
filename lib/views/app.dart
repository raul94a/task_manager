import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/main_option_enum.dart';
import 'package:task_manager/provider/main_option_provider.dart';
import 'package:task_manager/views/features/lateral_bar/lateral_bar.dart';
import 'package:task_manager/views/features/project_page/project_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuOverlay(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                const LateralBar(),
                Expanded(child: Consumer(builder: (ctx, ref, _) {
                  final mainOption = ref.watch(mainOptionState);

                  if (mainOption.selectedOptionFromMainMenu ==
                      MainOption.stats) {
                    return const Center(
                      child: Text('COnstrucction'),
                    );
                  } else if (mainOption.selectedOptionFromMainMenu ==
                      MainOption.settings) {
                    return const Center(
                      child: Text('COnstrucction'),
                    );
                  }

                  return const ProjectPage();
                }))
              ],
            )
          ],
        ),
      ),
    );
  }
}

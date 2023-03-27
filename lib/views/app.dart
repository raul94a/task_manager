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
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                tileMode: TileMode.decal,
                colors: [
                  Color.fromARGB(255, 15, 15, 15),
                  Color.fromARGB(245, 0, 0, 0),
                  Color.fromARGB(255, 22, 21, 21),
                  Color.fromARGB(255, 63, 62, 62)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
      ),
    );
  }
}

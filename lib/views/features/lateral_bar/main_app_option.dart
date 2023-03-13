import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/enums/main_option_enum.dart';
import 'package:task_manager/logic/main_option_bloc.dart';

class MainAppOption extends StatelessWidget {
  const MainAppOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => MainOptionItem(index: index)),
    );
  }
}

class MainOptionItem extends ConsumerWidget {
  const MainOptionItem({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          final mainOptBloc = MainOptionBloc(ref: ref);
          mainOptBloc.changeOption(option: mainOptionsByIndex[index]!);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Icon(iconDataByIndex[index], size:  60,),
              const SizedBox(
                height: 5,
              ),
              Text(optionsByIndex[index]!)
            ],
          ),
        ),
      ),
    );
  }

  static const Map<int, IconData> iconDataByIndex = {
    0: Icons.blender,
    1: Icons.graphic_eq,
    2: Icons.settings
  };

  static const Map<String, MainOption> options = {
    "Proyectos": MainOption.projects,
    "Stats": MainOption.stats,
    "Ajustes": MainOption.settings
  };
  static const Map<int, MainOption> mainOptionsByIndex = {
    0: MainOption.projects,
    1: MainOption.stats,
    2: MainOption.settings
  };

  static const Map<int, String> optionsByIndex = {
    0: "Proyectos",
    1: "Stats",
    2: "Ajustes"
  };
}

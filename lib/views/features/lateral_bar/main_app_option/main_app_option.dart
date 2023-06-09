import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/core/enums/main_option_enum.dart';
import 'package:task_manager/core/extensions/ref_extensions.dart';
import 'package:task_manager/logic/main_option_bloc.dart';
import 'package:task_manager/provider/main_option_provider.dart';
import 'package:task_manager/provider/theme_provider.dart';
import 'package:task_manager/views/styles/app_colors.dart';

class MainAppOption extends StatelessWidget {
  const MainAppOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: List.generate(3, (index) => MainOptionItem(index: index)),
        ),
        const _SwitchThemeButton()
      ],
    );
  }
}

class _SwitchThemeButton extends ConsumerWidget {
  const _SwitchThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Center(
          child: GestureDetector(
              onTap: () => ref
                  .read(themeState.notifier)
                  .update((state) => state.copyWith(darkMode: !state.darkMode)),
              child: ref.lightMode
                  ? const Icon(
                      Icons.dark_mode,
                      size: 50,
                    )
                  : const Icon(
                      Icons.light_mode,
                      size: 50,
                    )),
        ),
      ),
    );
  }
}

class MainOptionItem extends ConsumerWidget {
  const MainOptionItem({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMainOption = ref.watch(mainOptionState);
    bool isSelected = false;
    switch (selectedMainOption.selectedOptionFromMainMenu) {
      case MainOption.projects:
        isSelected = index == 0;
        break;
      case MainOption.stats:
        isSelected = index == 1;

        break;
      case MainOption.settings:
        isSelected = index == 2;

        break;
    }
    final darkMode = ref.read(themeState).darkMode;
    final selecdtedColor = darkMode
        ? darkSelectedMainOptionColor
        : lightSelectedMainOptionColor;
    const unselectedColor = Colors.white;
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
              SvgPicture.asset(
                iconDataByIndex[index]!,
                width: 50,
                height: 50,
                color: isSelected ? selecdtedColor : unselectedColor,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                optionsByIndex[index]!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? selecdtedColor : Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  static const Map<int, String> iconDataByIndex = {
    0: 'assets/project.svg',
    1: 'assets/stats.svg',
    2: 'assets/settings.svg'
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

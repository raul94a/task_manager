import 'package:flutter/material.dart';
import 'package:task_manager/views/features/lateral_bar/secondary_app_option/secondary_app_option.dart';
import 'package:task_manager/views/features/lateral_bar/main_app_option/main_app_option.dart';
import 'package:task_manager/views/styles/app_colors.dart';

class LateralBar extends StatelessWidget {
  const LateralBar({super.key, required this.darkMode});
  final bool darkMode;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mainContainerWidth = size.width * 0.2;
    final mainOptionContainerWidth = mainContainerWidth * 0.4;
    final height = size.height;
    return Container(
      height: height,
      width: mainContainerWidth,
      constraints: const BoxConstraints(minWidth: 250, maxWidth: 450),
      decoration: BoxDecoration(
        border: const Border(
          right: BorderSide(color: Colors.black, width: 1.5),
        ),
        color: !darkMode ? lateralBarBg : Color.fromARGB(246, 56, 56, 56),
      ),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(color: Colors.black, width: 0.65))),
            width: mainOptionContainerWidth,
            child: const MainAppOption(),
          ),
          Expanded(
            child: Container(
              height: height,
              child: SecondaryAppOption(
                  secondaryContainerWidth: mainContainerWidth * 0.6),
            ),
          )
        ],
      ),
    );
  }
}

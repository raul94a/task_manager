import 'package:flutter/material.dart';

import 'package:task_manager/views/features/lateral_bar/main_app_option.dart';
import 'package:task_manager/views/features/lateral_bar/secondary_app_option.dart';

class LateralBar extends StatelessWidget {
  const LateralBar({super.key});

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
      child: Row(
        children: [
          SizedBox(
            width: mainOptionContainerWidth,
            child: const MainAppOption(),
          ),
          Expanded(
            
            child: Container(
              height: height,
              color: Colors.blue,
              child: const SecondaryAppOption(),
            ),
          )
        ],
      ),
    );
  }
}

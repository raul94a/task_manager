import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:task_manager/views/features/lateral_bar/lateral_bar.dart';

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
                LateralBar(),
                Expanded(
                    child: Container(
                  color: Colors.pink,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}

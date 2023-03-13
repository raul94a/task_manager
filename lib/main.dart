import 'package:flutter/material.dart';
import 'package:mysql_manager/mysql_manager.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Init db connection
  MySQLManager.instance;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

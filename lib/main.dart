import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_manager/mysql_manager.dart';
import 'package:task_manager/logic/project_bloc.dart';
import 'package:task_manager/provider/project_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Init db connection
  MySQLManager.instance.init();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: const Scaffold(
        body: Center(
          child: ProjectForm(),
        ),
      ),
    );
  }
}

class ProjectForm extends ConsumerStatefulWidget {
  const ProjectForm({super.key});

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(projectsState);
    if (notifier.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
              hintText: 'Introduce el nombre del proyecto'),
        ),
        ElevatedButton(
            onPressed: () {
              ProjectBloc(ref: ref, context: context)
                  .createProject(controller.text);
            },
            child: const Text('Crear projecto'))
      ],
    );
  }
}
